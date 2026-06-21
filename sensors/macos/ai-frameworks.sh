#!/bin/sh
found=0

# Conda check
for p in "$HOME/opt/anaconda3" "$HOME/opt/miniconda3" "$HOME/anaconda3" "$HOME/miniconda3" \
  "/opt/anaconda3" "/opt/miniconda3" "/opt/homebrew/Caskroom/miniforge/base"; do
  if [ -f "$p/bin/conda" ]; then
    name="Anaconda"; echo "$p" | grep -iq "miniconda\|miniforge" && name="Miniconda"
    printf "%s|%s\n" "$name" "$p"
    found=1
  fi
done

# pip dist-info scan
for sp in "$HOME/Library/Python/"*/lib/python/site-packages \
  "/usr/local/lib/python"*/site-packages \
  "/opt/homebrew/lib/python"*/site-packages; do
  [ -d "$sp" ] || continue
  for pkg in torch tensorflow transformers keras scikit_learn langchain llama_index \
    openai anthropic huggingface_hub diffusers sentence_transformers accelerate datasets peft llama_cpp_python; do
    di=$(find "$sp" -maxdepth 1 -name "${pkg}-*.dist-info" 2>/dev/null | head -1)
    if [ -n "$di" ]; then
      ver=$(basename "$di" | sed "s/${pkg}-//;s/\.dist-info//")
      pretty=$(echo "$pkg" | sed 's/_/ /g')
      printf "%s|%s\n" "$pretty" "$ver"
      found=1
    fi
  done
done

[ "$found" -eq 0 ] && echo "[No AI Frameworks Found]"