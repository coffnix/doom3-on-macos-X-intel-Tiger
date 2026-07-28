#!/bin/bash

ISO_DIR="/Doom 3/doom 3 macos x intel iso"
ISO_FILE="Doom 3 for Macintosh DVD.toast"
VOLUME="/Volumes/Doom 3"

BIN="/Doom 3/Doom 3.app/Contents/MacOS/Doom 3"
CMD="/tmp/doom3-bypass-test.gdb"
OUT="$HOME/saida-bypass-dvd.txt"

cleanup()
{
    echo
    echo "Unmounting Doom 3 DVD image..."

    if mount | grep -q " on $VOLUME "; then
        hdiutil detach "$VOLUME"

        if [ $? -ne 0 ]; then
            echo "WARNING: Unable to unmount $VOLUME"
        fi
    fi

    rm -f "$CMD"
}

# Executed whenever this script exits
trap cleanup EXIT

# Make Ctrl+C terminate GDB and then run cleanup
trap 'exit 130' INT
trap 'exit 143' TERM
trap 'exit 129' HUP

# Check whether the DVD image is really mounted
if ! mount | grep -q " on $VOLUME "; then
    echo "Doom 3 DVD image is not mounted."
    echo "Mounting..."

    hdiutil attach "$ISO_DIR/$ISO_FILE"

    if [ $? -ne 0 ]; then
        echo "ERROR: Unable to mount $ISO_FILE"
        exit 1
    fi
fi

if [ ! -x "$BIN" ]; then
    echo "ERROR: Doom 3 executable not found:"
    echo "$BIN"
    exit 1
fi

rm -f "$CMD" "$OUT"

cat > "$CMD" <<'EOF'
set pagination off
set confirm off

set logging file ~/saida-bypass-dvd.txt
set logging overwrite on
set logging on

# Return value of the first check, probably checkOS
break *0x930bc
commands
silent
printf "\ncheckOS returned eax = 0x%x\n", $eax
continue
end

# Return value of the second check, checkDVD
break *0x930dc
commands
silent
printf "\ncheckDVD returned eax = 0x%x\n", $eax
printf "Forcing checkDVD to return success.\n"
set $eax = 1
continue
end

run

set logging off
quit
EOF

echo "Starting Doom 3..."
gdb "$BIN" -x "$CMD"

RET=$?

# Calling exit triggers the cleanup function
exit "$RET"
