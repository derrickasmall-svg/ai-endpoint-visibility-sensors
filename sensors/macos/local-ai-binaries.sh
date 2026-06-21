#!/bin/sh
targets="ollama lmstudio cursor jan gpt4all koboldcpp llamafile pinokio msty localai nextchat openwebui anytype oobabooga"
found=0
for t in $targets; do
  pid=$(pgrep -ix "$t" 2>/dev/null | head -1)
  if [ -n "$pid" ]; then
    path=$(ps -p "$pid" -o comm= 2>/dev/null)
    printf "%s|%s\n" "$t" "$path"
    found=1
  fi
done
for t in $targets; do
  for base in "/Applications" "$HOME/Applications" "$HOME/.local/bin" "/usr/local/bin" "/opt/homebrew/bin"; do
    [ -d "$base" ] || continue
    hit=$(find "$base" -maxdepth 5 -iname "${t}*" \( -type f -o -type l \) 2>/dev/null | head -1)
    if [ -n "$hit" ]; then
      printf "%s|%s\n" "$t" "$hit"
      found=1
    fi
  done
done
[ "$found" -eq 0 ] && echo "[No Local AI Binaries Found]"



