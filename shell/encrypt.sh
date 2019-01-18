#!/bin/sh

#  encrypt.sh

src_manifest=$1
target=$2
en_manifest="$target"


if [ -f "$en_manifest" ]; then
    rm "$en_manifest"
fi

echo $src_manifest
echo $en_manifest
# 这里的-d 参数判断$target是否存在
#if [ ! -d "$target" ]; then
#    mkdir -p "$target"
#fi
#chmod -R 777 "$target"
#加密
./shell/Encrypt -k "ABCD" -in "$src_manifest" -out "$en_manifest"
