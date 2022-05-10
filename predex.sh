#!/data/data/com.termux/files/usr/bin/sh

# Make sure libs/dex directory exists.
if [ ! -d "./libs/dex" ]; then
  mkdir libs/dex
fi

# Dex all files.
for file in libs/*.jar; do
  echo "[dx] Compiling $file"
  dx --dex --verbose --num-threads=4 \
    --output "libs/dex/$(basename $file)" $file
done
