#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#LLAMA="$ROOT/llama.cpp/build/bin/Release"
LLAMA="$ROOT/llama.cpp/build/bin"
#MODEL="$ROOT/models/Qwen3.6-35B-A3B-GGUF/Qwen3.6-35B-A3B-UD-Q6_K_XL.gguf"
MODEL="$ROOT/models/Qwen3.6-35B-A3B-MTP-GGUF/Qwen3.6-35B-A3B-UD-IQ3_XXS.gguf"

#exec "$LLAMA/llama-server.exe" \
exec "$LLAMA/llama-server" \
  -m "$MODEL" \
  --host 127.0.0.1 \
  --port 8080 \
  -ngl all \
  --n-cpu-moe 4 \
  --fit off \
  --load-mode none \
  -c 262144 \
  -b 4096 \
  -ub 512 \
  --cache-ram 2048 \
  --ctx-checkpoints 8 \
  --checkpoint-min-step 2048 \
  -fa on \
  -ctk q8_0 \
  -ctv q8_0 \
  -t 8 \
  -tb 16 \
  --fit off \
  --reasoning on \
  --reasoning-format deepseek \
  --parallel 1 \
  --reasoning-effort high \
  --reasoning-budget 8096 \
  \
  --temp 0.6 \
  --top-p 0.95 \
  --top-k 20 \
  --min-p 0.0 \
  --presence-penalty 0.0 \
  --repeat-penalty 1.0 \
  \
  --cont-batching \
  --metrics
