#!/system/bin/sh

TARGET_DIR="/data/adb/modules/"
pwddir="$(pwd)"
OUTPUT_DIR="$pwddir/files/modules/"
temp_dirs=("/tmp" "/var/tmp" "/Temp" "/Users/*/Library/Caches" "/storage/emulated/0/Android/data/bin.mt.plus/temp")
for dir in "${temp_dirs[@]}"; do
    if [[ $current_dir == $dir* ]]; then
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本"
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本"
        echo "The current directory is a temporary directory or its subdirectory. Please extract to another directory before executing the script."
        exit 0
    fi
done
if [ "$(whoami)" != "root" ]; then
   echo "此脚本必须以root权限运行。请使用root用户身份运行此脚本。"
   echo "This script must be run with root privileges. Please run this script as a root user."
   exit 1
fi
for DIR in "$TARGET_DIR"*/; do

    if [ ! -d "$DIR" ]; then
        continue
    fi

    DIR_NAME=$(basename "$DIR")

    echo "Processing directory: $DIR_NAME"

    OUTPUT_FILE="$OUTPUT_DIR/${DIR_NAME}.zip"
    if [ -d /data/adb/magisk/ ]; then
    echo "Magisk环境已检测到，正在备份模块。"
    /data/adb/magisk/busybox zip -r "$OUTPUT_FILE" "$DIR/"
    return_code=$?
elif [ -d /data/adb/ksu ]; then
    echo "KernelSU环境已检测到，正在备份模块。"
    /data/adb/ksu/bin/busybox zip -r "$OUTPUT_FILE" "$DIR/"
    return_code=$?
elif [ -d /data/adb/ap ]; then
    echo "APatch环境已检测到，正在备份模块。"
    /data/adb/apd/bin/busybox zip -r "$OUTPUT_FILE" "$DIR/"
    return_code=$?
fi
    if [ "$return_code" -eq 0 ]; then
        echo "Successfully created archive: $OUTPUT_FILE"
    else
        echo "Failed to create archive for directory: $DIR_NAME"
    fi
done
echo "All directories have been processed."
