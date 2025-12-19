-- Custom linemode to show size and modification time
function Linemode:size_and_mtime()
    local time = math.floor(self._file.cha.mtime or 0)
    local time_str = ""

    if time == 0 then
        time_str = ""
    elseif os.date("%Y", time) == os.date("%Y") then
        -- Same year: show "Mon DD HH:MM"
        time_str = os.date("%b %d %H:%M", time)
    else
        -- Different year: show "Mon DD  YYYY"
        time_str = os.date("%b %d  %Y", time)
    end

    -- Get file size
    local size = self._file:size()
    local size_str = size and ya.readable_size(size) or "-"

    -- Right-align the size (pad to 8 characters) and add the time
    return ui.Line(string.format("%8s %s", size_str, time_str))
end
