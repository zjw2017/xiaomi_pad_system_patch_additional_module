#!/bin/bash
# shellcheck disable=SC2086
set -e

workfile="$(cd "$(dirname "$0")" && pwd)"
ExtractErofs="$workfile/common/binary/extract.erofs"
chmod +x $ExtractErofs
ImageExtRactorLinux="$workfile/common/binary/imgextractorLinux"
chmod u+wx "$ImageExtRactorLinux"

TMPDir="$workfile/tmp/"
DistDir="$workfile/dist/"
payload_img_dir="${TMPDir}payload_img/"
pre_patch_file_dir="${TMPDir}pre_patch_file/"
patch_mods_dir="${TMPDir}patch_mods/"
release_dir="${TMPDir}release/"
batch_config_file="$workfile/batch_rom_list.txt"
batch_output_dir="$workfile/batch_dist"

input_rom_version=""
input_rom_url=""
input_android_target_version="15"
input_image_fs="erofs"
input_device_name=""
is_batch_mode=false

# 判断是否 batch 模式
if [[ "$1" == "--batch" ]]; then
  is_batch_mode=true
fi

# 参数解析
while [[ $# -gt 0 ]]; do
  case "$1" in
    --rom)
      input_rom_version="$2"
      shift 2
      ;;
    --url)
      input_rom_url="$2"
      shift 2
      ;;
    --android)
      input_android_target_version="$2"
      shift 2
      ;;
    --fs)
      input_image_fs="$2"
      shift 2
      ;;
    --device)
      if [[ "$is_batch_mode" == true ]]; then
        input_device_name="$2"
        shift 2
      else
        echo "❌ 错误：--device 参数仅可用于 --batch 模式。" >&2
        exit 1
      fi
      ;;
    --batch)
      shift
      ;;
    *)
      echo "❌ 未知参数: $1"
      exit 1
      ;;
  esac
done

if [[ "$is_batch_mode" == true ]]; then
  echo "🧹 清理旧的 batch 输出目录: $batch_output_dir"
  sudo rm -rf "$batch_output_dir"
  mkdir -p "$batch_output_dir"

  if [[ ! -f "$batch_config_file" ]]; then
    echo "❌ 批量构建配置文件不存在: $batch_config_file" >&2
    exit 1
  fi

  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" == \#* ]] && continue

    rom_version=$(echo "$line" | grep -oP '(?<=--rom\s)[^ ]+')
    device_name=$(echo "$line" | grep -oP '(?<=--device\s)[^ ]+')

    if [[ -z "$device_name" ]]; then
      echo "❌ 错误：该行缺少 --device 参数：" >&2
      echo "   $line" >&2
      exit 1
    fi

    # ⚠️ 移除 device 参数（防止传递到构建脚本）
    clean_line=$(echo "$line" | sed -E 's/--device(=|\s+)([^"'\'' ]+|"[^"]*"|'\''[^'\'']*'\'')//g')

    echo "🚀 开始处理: $clean_line"
    bash "$0" $clean_line

    if [[ -f "$DistDir${rom_version}.zip" ]]; then
      mkdir -p "$batch_output_dir/$device_name"
      mv "$DistDir${rom_version}.zip" "$batch_output_dir/$device_name/${rom_version}.zip"
      echo "📁 构建结果已移动到: $batch_output_dir/$device_name/${rom_version}.zip"
    else
      echo "⚠️ 未找到输出文件: $DistDir${rom_version}.zip"
    fi
  done < "$batch_config_file"

  echo "✅ 批量构建完成"
  exit 0
fi

# 非 batch 模式检查必填参数
if [[ -z "$input_rom_version" || -z "$input_rom_url" ]]; then
  echo "❌ 错误：必须提供 --rom 和 --url 参数。" >&2
  exit 1
fi

# Android 版本验证
case "$input_android_target_version" in
  14|15) ;;
  *)
    echo "❌ 错误：不支持的 Android 版本：$input_android_target_version，仅支持 14 或 15。" >&2
    exit 1
    ;;
esac

# 镜像格式验证
if [[ "$input_image_fs" != "erofs" && "$input_image_fs" != "ext4" ]]; then
  echo "❌ 镜像解压方式仅支持 erofs 或 ext4，当前为: $input_image_fs"
  exit 1
fi

echo "🧹 清理并准备临时目录..."
sudo rm -rf "$TMPDir"
mkdir -p "$TMPDir" "$DistDir" "$payload_img_dir" "$pre_patch_file_dir" "$patch_mods_dir" "$release_dir"

echo "🔍 检查 payload_dumper 是否可用..."
if ! command -v payload_dumper >/dev/null 2>&1; then
  echo "❌ 错误：payload_dumper 未安装。" >&2
  exit 1
fi

echo "⬇️ 获取 system_ext.img..."
payload_dumper --partitions system_ext --out "$payload_img_dir" "$input_rom_url"

if [ ! -f "${payload_img_dir}system_ext.img" ]; then
  echo "❌ 找不到 system_ext.img" >&2
  exit 1
fi

# 解包
if [[ "$input_image_fs" == "erofs" ]]; then
  "$ExtractErofs" -i "${payload_img_dir}system_ext.img" -x -c "$workfile/common/system_ext_unpak_list.txt" -o "$pre_patch_file_dir"
else
  sudo "$ImageExtRactorLinux" "${payload_img_dir}system_ext.img" "$pre_patch_file_dir"
fi

# 校验解包文件
system_ext_unpak_list_file="$workfile/common/system_ext_unpak_list.txt"
while IFS= read -r line || [[ -n "$line" ]]; do
  file=$(echo "$line" | xargs)
  [ -z "$file" ] && continue
  full_path="${pre_patch_file_dir}system_ext${file}"
  if [ ! -f "$full_path" ]; then
    echo "❌ 缺失文件: system_ext${file}" >&2
    exit 1
  fi
done < "$system_ext_unpak_list_file"

# 模组构建
cp -a "$workfile/mods/." "$patch_mods_dir"
cp -f "${pre_patch_file_dir}system_ext/framework/miui-services.jar" "${patch_mods_dir}/miui-services-Smali/miui-services.jar"
bash "${patch_mods_dir}/miui-services-Smali/run.sh" "$input_android_target_version"
cp -f "${pre_patch_file_dir}system_ext/priv-app/MiuiSystemUI/MiuiSystemUI.apk" "${patch_mods_dir}/MiuiSystemUISmali/MiuiSystemUI.apk"
bash "${patch_mods_dir}/MiuiSystemUISmali/run.sh" "$input_android_target_version"

# 校验输出
patched_files=(
  "miui-services-Smali/miui-services_out.jar"
  "MiuiSystemUISmali/MiuiSystemUI_out.apk"
)
for file in "${patched_files[@]}"; do
  if [ ! -f "${patch_mods_dir}${file}" ]; then
    echo "❌ 缺失补丁文件: ${file}" >&2
    exit 1
  fi
done

# 打包模块
cp -a "$workfile/module_src/." "$release_dir"
mkdir -p "${release_dir}system/system_ext/framework/"
cp -f "${patch_mods_dir}miui-services-Smali/miui-services_out.jar" "${release_dir}system/system_ext/framework/miui-services.jar"
mkdir -p "${release_dir}system/system_ext/priv-app/MiuiSystemUI/"
cp -f "${patch_mods_dir}MiuiSystemUISmali/MiuiSystemUI_out.apk" "${release_dir}system/system_ext/priv-app/MiuiSystemUI/MiuiSystemUI.apk"

# 更新 module.prop 和 system.prop
sed -i "s/^version=.*/version=${input_rom_version}/" "${release_dir}module.prop"
if [ "$input_android_target_version" -eq 14 ]; then
  sed -i '/^ro\.config\.sothx_project_treble_support_vertical_screen_split/d' "${release_dir}system.prop"
  sed -i '/^ro\.config\.sothx_project_treble_vertical_screen_split_version/d' "${release_dir}system.prop"
fi

final_zip="${DistDir}${input_rom_version}.zip"
cd "$release_dir"
zip -r "$final_zip" ./*
cd "$workfile"
echo "✅ 构建完成：$final_zip"
