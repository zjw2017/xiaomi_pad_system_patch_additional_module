#!/bin/bash
set -e

workfile="$(cd "$(dirname "$0")" && pwd)"
batch_config_file="$workfile/batch_rom_list.txt"
batch_output_dir="$workfile/batch_dist"

echo "🧹 清理旧的 batch 输出目录: $batch_output_dir"
rm -rf "$batch_output_dir"
mkdir -p "$batch_output_dir"

if [[ ! -f "$batch_config_file" ]]; then
  echo "❌ 批量构建配置文件不存在: $batch_config_file" >&2
  exit 1
fi

# 去除引号的函数
strip_quotes() {
  echo "$1" | sed -e 's/^"//' -e 's/"$//'
}

while IFS= read -r line || [[ -n "$line" ]]; do
  [[ -z "$line" || "$line" == \#* ]] && continue

  echo "🚀 开始构建: $line"

  # 提取device和rom版本（去除引号）
  device_name=$(echo "$line" | grep -oP -- '--device\s+"\K[^"]+' || echo "$line" | grep -oP -- '--device\s+\K[^ ]+')
  rom_version=$(echo "$line" | grep -oP -- '--rom\s+"\K[^"]+' || echo "$line" | grep -oP -- '--rom\s+\K[^ ]+')
  
  # 去除可能存在的引号
  device_name=$(strip_quotes "$device_name")
  rom_version=$(strip_quotes "$rom_version")

  if [[ -z "$device_name" || -z "$rom_version" ]]; then
    echo "❌ 配置行缺少 --device 或 --rom 参数: $line"
    exit 1
  fi

  # 执行构建命令（保持原始参数不变）
  chmod +x build.sh
  eval "./build.sh $line" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"

  # 构建完后移动输出（使用去除引号后的名称）
  output_file="$workfile/dist/${rom_version}.zip"
  if [[ -f "$output_file" ]]; then
    mkdir -p "$batch_output_dir/$device_name"
    mv "$output_file" "$batch_output_dir/$device_name/${rom_version}.zip"
    echo "📁 构建结果已移动到: $batch_output_dir/$device_name/${rom_version}.zip"
  else
    echo "⚠️ 未找到输出文件: $output_file"
  fi
done < "$batch_config_file"

echo "✅ 批量构建完成"