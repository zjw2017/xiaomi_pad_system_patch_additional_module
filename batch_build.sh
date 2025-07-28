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

while IFS= read -r line || [[ -n "$line" ]]; do
  [[ -z "$line" || "$line" == \#* ]] && continue

  # 取出device和rom版本
  device_name=$(echo "$line" | grep -oP '(?<=--device\s)[^ ]+')
  rom_version=$(echo "$line" | grep -oP '(?<=--rom\s)[^ ]+')

  if [[ -z "$device_name" || -z "$rom_version" ]]; then
    echo "❌ 配置行缺少 --device 或 --rom 参数: $line"
    exit 1
  fi

  echo "🚀 开始构建: $line"

# 去除 --device 参数及其值（支持格式：--device xyz 或 --device=xyz）
  clean_line=$(echo "$line" | sed -E 's/[[:space:]]*--device(=|[[:space:]]+)([^ ]+)//g')

  # 直接调用 build.sh，参数全部传递过去
  # 注意要正确处理参数带引号的情况，下面简单示例假设参数无空格
  # 如果参数有空格需要用更复杂的解析逻辑
  eval "./build.sh $clean_line"

  # 构建完后移动输出
  if [[ -f "$workfile/dist/${rom_version}.zip" ]]; then
    mkdir -p "$batch_output_dir/$device_name"
    mv "$workfile/dist/${rom_version}.zip" "$batch_output_dir/$device_name/${rom_version}.zip"
    echo "📁 构建结果已移动到: $batch_output_dir/$device_name/${rom_version}.zip"
  else
    echo "⚠️ 未找到输出文件: $workfile/dist/${rom_version}.zip"
  fi
done < "$batch_config_file"

echo "✅ 批量构建完成"