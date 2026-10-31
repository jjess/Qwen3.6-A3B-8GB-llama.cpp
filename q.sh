#!/usr/bin/env bash
set -euo pipefail


# 20261031:
# 	MTP (multitoken prediction)
# 	--spec-type draft-mtp --spec-draft-n-max 3
#
#	-np: number of parallel inference slots
#	-cb: continuous batching
#	concurrent demands to the model
# 	it requires more memory so context is decreased to 192K
#	-np 3 -cb
#       -np 2 -cb
#
#	context 256K
#	  -c 262144 \
#	context 192K
#	  -c 196608 \
#	context 150K
#	  -c 153600 \
#	context 128K
#	  -c 131072 \
#
#	sleep seconds 10min
# 	--sleep-idle-seconds 600
#
#
#	cache ram
#	increase it could lead to quick ram consumption
#	--cache-ram 4096 \
#	--cache-ram 2048 \
#

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
  -c 196608 \
  -b 4096 \
  -ub 512 \
  --cache-ram 4096 \
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
  --spec-type draft-mtp --spec-draft-n-max 3 \
  \
  -np 2 -cb \
  \
  --sleep-idle-seconds 600 \
  \
  --cont-batching \
  --metrics
