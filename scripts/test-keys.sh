#!/bin/bash

echo "Key sequence tester"
echo "Press Option+Shift+Left or Option+Shift+Right (Ctrl+C to exit)"
echo "---"

while true; do
    # Read one character at a time, showing hex values
    IFS= read -rsn1 char

    if [[ $char == $'\e' ]]; then
        # Escape sequence detected, read the rest
        seq="$char"
        while IFS= read -rsn1 -t 0.001 char; do
            seq+="$char"
        done

        # Show the sequence
        echo -n "Escape sequence: "
        printf '%s' "$seq" | od -An -tx1 | tr -d '\n'
        echo -n " | String: "
        printf '%q\n' "$seq"
    else
        printf 'Regular char: %q\n' "$char"
    fi
done
