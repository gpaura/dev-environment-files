import os
import csv
import traceback
import BatchImport.Helper_Master as HM
import BatchImport.Helper_HADE as HH
import BatchImport.Helper_Transaction as HT
import BatchImport.Helper_HostRelation as HHR
import BatchImport.Base_Row_Handlers as BRH
import BatchImport.ProductandType as PT
import BatchImport.HostAcctReturn as HAR
import BatchImport.Helper_Closed as HC
from Common_Utils import *

#----------xxxxxxxxxxxxxxXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXxxxxxxxx---------
#--------xxxxxxXXXXXXX Add Custom Function Below XXXXXXXXxxxxxxxx-------
#----------xxxxxxxxxxxxxxXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXxxxxxxxx---------

def get_product_data(daily, logger):
    """
    This function connects to the database and returns what is ammounts to the Q2_ProductAndType view.
    This is in the form of XML, the ProductandType module then parses that into python object.
    The data object returned by PT.get_product_data contains with in its row attribute each row of that view.
    the custom work needed here is to build a dictionary, namely the product_and_type_data of the daily,
    in a way that can be used to look up product info later.

    For DCI, we need two ways to look up product data
    From the HostProductCode, we need to get back ProductID and ProductTypeID,
    Each is pulled back via their name as a key to the look up result of the HostProductCode
    i.e.
    daily.product_and_type_data[HostProductCode]['ProductID'] gives you the ProductID of the given HostProductCode
    this is used in the building of master nodes
    The other is from ProductID we get back HydraProductCode and HostProductCode,
    this is used for HADE and Transaction nodes
    """
    logger.write_line(['get_product_data', 'START'])
    key_list = [
        ('ProductTypeID', 'HostProductCode'),
        ('HostProductTypeCode', 'HostProductCode'),
        ('ProductID',)]
    pt_obj, base_dict = PT.get_product_data(daily, key_list, logger)
    daily.product_and_type_data = base_dict
    for row in pt_obj.row:
        #configure any non general mappings here
        pass
    logger.write_line(['get_product_data', 'END'])

def extract_host_account_data(raw_host_data, target_dict, daily):
    """
    This function takes the return from inserting a master temp file and builds a dict of host account ids for look
     up later.
    This is in the form of XML, the HostAccountReturn module then parses this into a python object.
    The data points avalible are as follows:
    HostAccountID, AcctNumberInternal, CIFInternal,  CIFExternal, ProductTypeID, ProductID, OldProductID,
    NewAcctStatus, OldAcctStatus, DataAsOfDate
    You will be able to pull any of these out of each of the  data object returned by HAR.obj_wrapper
    
    need to look at the return from har, clean up the names maybe
    
    """
    # need more checking here for bad master import...
    key_list = [
        ('AccountNumberInternal', 'ProductID'),
        ('AccountNumberInternal', 'ProductTypeID'),]
    uar_obj, base_dict = HAR.extract_host_account_data(key_list, raw_host_data, daily)
    daily.host_account_id_data.update(base_dict)
    for row in uar_obj.AccountResults[0].HostAccount:
        #add custom mappings here
        pass
    return (True, '')
                             
def convert_HostProductCode(in_str):
    return 'VPL'

def convert_DorC(in_str):
    if in_str == '-':
        return 'C'
    else:
        return 'D'

def decode_signed_numeric(in_str):
    # in last_char_key[0], 'p' will stand for positive and 'n' will stand for negative
    last_char_key = {
        '{':('', '0'),
        'A':('', '1'),
        'B':('', '2'),
        'C':('', '3'),
        'D':('', '4'),
        'E':('', '5'),
        'F':('', '6'),
        'G':('', '7'),
        'H':('', '8'),
        'I':('', '9'),
        '}':('-', '0'),
        'J':('-', '1'),
        'K':('-', '2'),
        'L':('-', '3'),
        'M':('-', '4'),
        'N':('-', '5'),
        'O':('-', '6'),
        'P':('-', '7'),
        'Q':('-', '8'),
        'R':('-', '9')}

    temp_str = last_char_key[in_str[-1]][0] + in_str.replace(in_str[-1], last_char_key[in_str[-1]][1])
    return temp_str
    
def money_test(in_str):
    try:
        return '{:.2f}'.format(float(in_str) *.01)
    except:
        return in_str
        
def convert_cents_CashAdvLimit(in_str):
    return '{:.2f}'.format(float(in_str) *.01)


def get_cc_cif_from_file(daily, logger):
    logger.write_line(['START', 'Retrieving Credit Card CIF Information'])
    with open(os.path.join(
            daily.input_file_path, daily.supplemental_cif_file)) as _f:
        csv_reader = csv.reader(_f)
        for row in csv_reader:
            # Only care about lines with actual data
            if row[0].strip():
                daily.supplemental_cif_data[
                    row[0].strip().lstrip('0')] = row[1].strip().lstrip('0')
    logger.write_line(['END', 'Retrieving Credit Card CIF Information'])


#----------xxxxxxxxxxxxxxXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXxxxxxxxx---------
#--------==xxxxxxXXXXXXX End Custom Function XXXXXXXXxxxxxxxx===--------
#----------xxxxxxxxxxxxxxXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXxxxxxxxx---------



def exec_preprocess_functions(daily, logger):
    """
    Place any preprocess functions below. 
    Only functions needed to gather data needed for the import of master, hade, tran should be listed here.
    """
    get_product_data(daily, logger)
    get_cc_cif_from_file(daily, logger)


def exec_postprocess_functions(daily, logger):
    """
    Place any preprocess functions below. 
    Only functions needed to gather data needed for the import of master, hade, tran should be listed here.
    """
    pass
    


def parse_CC_account(row, config, daily, logger):
    try:
        field_def = {
            'LastPmtAmt': (160,13,strm('strip'),decode_signed_numeric,convert_cents),
            'DelinquentAmt': (197,13,strm('strip'),decode_signed_numeric,convert_cents),
            'CreditLineAmt': (30,13,strm('strip'),decode_signed_numeric,convert_cents),
            #'CashAdvLimit': (30,13,strm('strip'),decode_signed_numeric,convert_cents_CashAdvLimit),
            'NumOutAuthAmt': (82,3,strm('strip'),strm('lstrip','0')),
            'AccountNumberInternal': (14,16,strm('strip')),
            'CIFExternal': (256,9,strm('strip')),
            'CreditLineAvail': (56,13,strm('strip'),decode_signed_numeric,convert_cents),
            'NextPmtDt': (224,8,strm('strip'),map_dates('%m%d%Y')),
            'OrigDt': (845,8,strm('strip'),map_dates('%Y%m%d')),
            'DefaultPwd': (256,9,strm('strip')),
            'OutAuthAmt': (69,13,strm('strip'),decode_signed_numeric,convert_cents),
            'SSN': (256,9,strm('strip')),
            'MinPmtDue': (210,13,strm('strip'),decode_signed_numeric,convert_cents),
            'HostProductCode': (1,1,strm('strip'),convert_HostProductCode),
            'CurBal': (43,13,strm('strip'),decode_signed_numeric,convert_cents),
            'LastPmtDt': (173,8,strm('strip'),map_dates('%m%d%Y')),
            'NumMonthsPastDue': (102,1,strm('strip')),
        }
        if row[3:10] == 'TRAILER' or row[2:8] == 'HEADER' or row[3:9] == 'HEADER' or len(row) < 5:
            return (None, 'Skipped Header/Footer')
        tmp_row = BRH.parse_by_offset(row, field_def)
        if tmp_row.AccountNumberInternal in daily.dup_account_list:
            return (None, 'Skipping Duplicate Account')
        else:
            daily.dup_account_list.append(tmp_row.AccountNumberInternal)
        tmp_row.DataAsOfDate = mk_now_SOAP()
        tmp_row.BranchID = '1'
        tmp_row.AccountStatusID = '1'
        tmp_row.IsExternalAccount = False
        tmp_row.SkipBalanceCheck = False
        tmp_row.HostProductTypeCode = 'XP'
        # Retrieving CIFInternal from supp file data set. Will assign old CIFInternal value to
        # account numbers not being sent in supp file.
        tmp_row.CIFInternal = daily.supplemental_cif_data.get(
            tmp_row.AccountNumberInternal, tmp_row.SSN)
        return (True, ((tmp_row.AccountNumberInternal, tmp_row.HostProductCode), tmp_row))
    # We only want to handle errors related to the format of the data
    # Any other issue should pass up the execution chain
    except BRH.RowHandlerError as e:
        traceback.print_exc(file=daily.error_logger.handle)
        logger.write_line(['ERROR', 'HANDLED by row parser, processing will continue'])
        return (False, (e, e.data, e.error))


def node_CC_account(row, config, daily, logger):
    #place all dictionary look up here, such as from the product or host account look up dictionaries
    try:
        ProductTypeID = daily.product_and_type_data[(
            ('HostProductTypeCode', row.HostProductTypeCode),('HostProductCode', row.HostProductCode))]['ProductTypeID']
        ProductID = daily.product_and_type_data[(
            ('HostProductTypeCode', row.HostProductTypeCode),('HostProductCode', row.HostProductCode))]['ProductID']
    except KeyError as e:
        traceback.print_exc(file=daily.error_logger.handle)
        return (False, ('could not match account in look up dict', row, e))
    #Any errors thrown after this point are set up issues, and not data issues. These will be terminal to the batch.
    attr_data = {
        'AccountNumberInternal': row.AccountNumberInternal,
        'ProductTypeID': ProductTypeID,
        'ProductID': ProductID,
        'SkipBalanceCheck': row.SkipBalanceCheck,
        'IsExternalAccount': row.IsExternalAccount,
        'CIFInternal': row.CIFInternal,
        'CIFExternal': row.CIFExternal,
        'DefaultPwd': row.DefaultPwd,
        'DataAsOfDate': row.DataAsOfDate,
        'BranchID': row.BranchID,
        'AccountStatusID': row.AccountStatusID,
        }
    daily.dup_account_list=[]
    return HM.build_xml_node(attr_data)

def node_CC_hade(row, config, daily, logger):
    try:
        ProductID = daily.product_and_type_data[(
            ('HostProductTypeCode', row.HostProductTypeCode),('HostProductCode', row.HostProductCode))]['ProductID']
        HostAccountID = daily.host_account_id_data[(('AccountNumberInternal', row.AccountNumberInternal),
            ('ProductID', ProductID))]['HostAccountID']
    except KeyError as e:
        traceback.print_exc(file=daily.error_logger.handle)
        return (False, ('could not match account in look up dict', row, e))
    #Any errors thrown after this point are set up issues, and not data issues. These will be terminal to the batch.
    attr_data = {
        'HostAccountID': HostAccountID,
        'CurBal': row.CurBal,
        'CreditLineAmt': row.CreditLineAmt,
        'CreditLineAvail': row.CreditLineAvail,
        'LastPmtAmt': row.LastPmtAmt,
        'LastPmtDt': row.LastPmtDt,
        'NextPmtDt': row.NextPmtDt,
        'OrigDt': row.OrigDt,
        #'CashAdvLimit': row.CashAdvLimit,
        'MinPmtDue': row.MinPmtDue,
        'DelinquentAmt': row.DelinquentAmt,
        'NumOutAuthAmt': row.NumOutAuthAmt,
        'OutAuthAmt': row.OutAuthAmt,
        'NumMonthsPastDue': row.NumMonthsPastDue,
        }
    attr_data = del_empty_hades(attr_data)
    return HH.build_xml_node(attr_data)


def parse_CC_transaction(row, config, daily, logger):
    try:
        field_def = {
            'PostDate': (43,6,strm('strip')),
            'AccountNumberInternal': (9,16,strm('strip')),
            'TxnDesc': (151,47,strm('strip')),
            'HostProductCode': (1,1,strm('strip'),convert_HostProductCode),
            'HostTranNumber': (296,26,strm('strip')),
            'DorC': (68,1,strm('strip'),convert_DorC),
            'TxnAmount': (55,13,strm('strip'),money_test),
            'ReasonCode': (39,2,strm('strip')),
            'HostTranCode': (37,4,strm('strip')),
            }
        
        if row[4:21] == 'DAILY POSTED TRAN' or len(row) < 5:
            return (None, 'Skipped Header/Footer')
        tmp_row = BRH.parse_by_offset(row, field_def)
        if tmp_row.PostDate == '000000':
            return (None, 'Skipped for no PostDate')
        else:
            tmp_row.PostDate = map_dates('%y%m%d')(tmp_row.PostDate)
        tmp_row.HostProductTypeCode = 'XP'

        return (True, ((tmp_row.AccountNumberInternal, tmp_row.HostProductCode), tmp_row))
    # We only want to handle errors related to the format of the data
    # Any other issue should pass up the execution chain
    except BRH.RowHandlerError as e:
        traceback.print_exc(file=daily.error_logger.handle)
        logger.write_line(['ERROR', 'HANDLED by row parser, processing will continue'])
        return (False, (e, e.data, e.error))


def node_CC_transaction(row, config, daily, logger):
    try:
        ProductID = daily.product_and_type_data[(
            ('HostProductTypeCode', row.HostProductTypeCode),('HostProductCode', row.HostProductCode))]['ProductID']
        HostAccountID = daily.host_account_id_data[(('AccountNumberInternal', row.AccountNumberInternal),
            ('ProductID', ProductID))]['HostAccountID']
    except KeyError as e:
        traceback.print_exc(file=daily.error_logger.handle)
        return (False, ('could not match account in look up dict', row, e))
    #Any errors thrown after this point are set up issues, and not data issues. These will be terminal to the batch.
    try:
        attr_data = {
            'HostAccountID': HostAccountID,
            'PostDate': row.PostDate,
            'TxnAmount': row.TxnAmount,
            'HostTranCode': row.HostTranCode,
            'TxnDesc': row.TxnDesc,
            'HostTranNumber': row.HostTranNumber,
            'DorC': row.DorC,
            } 
        return HT.build_xml_node(attr_data, daily)
    except Exception as e:
        logger.write_line([80 * '*'])
        traceback.print_exc(file = logger.handle)
        logger.write_line(['ERROR', 'HANDLED by row parser, processing will continue'])
        return (False, (Exception, e))