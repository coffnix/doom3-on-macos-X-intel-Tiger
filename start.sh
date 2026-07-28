#!/bin/bash

BIN="/Doom 3/Doom 3.app/Contents/MacOS/Doom 3"
CMD="/tmp/doom3-bypass-test.gdb"
OUT="$HOME/saida-bypass-dvd.txt"

rm -f "$CMD" "$OUT"

cat > "$CMD" <<'EOF'
set pagination off
set confirm off

set logging file ~/saida-bypass-dvd.txt
set logging overwrite on
set logging on

# Retorno do primeiro teste, provavelmente checkOS
break *0x930bc
commands
silent
printf "\ncheckOS retornou eax = 0x%x\n", $eax
continue
end

# Retorno do segundo teste, checkDVD
break *0x930dc
commands
silent
printf "\ncheckDVD retornou eax = 0x%x\n", $eax
printf "Forcando checkDVD a retornar sucesso.\n"
set $eax = 1
continue
end

run

set logging off
quit
EOF

gdb "$BIN" -x "$CMD"
