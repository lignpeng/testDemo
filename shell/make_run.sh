#!/bin/sh

#  make_run_bundle.sh
# chmod -R 777 encrypt.sh
# chmod -R 777 make_run.sh
# chmod -R 777 copy_manifest_to_proj.sh

# 插件列表配置文件的加解密
./shell/encrypt.sh "${SRCROOT}/testDemo/shell/hello.txt" "${SRCROOT}/testDemo/shell/hello.json"

# ./shell/copy_manifest_to_proj.sh ""
