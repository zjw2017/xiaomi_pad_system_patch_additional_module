#!/bin/bash
# shellcheck disable=SC2086
set -e

# 获取脚本所在目录（避免相对路径错误）
workfile="$(cd "$(dirname "$0")" && pwd)"
ExtractErofs="$workfile/common/binary/extract.erofs"
chmod +x $ExtractErofs

# 工作目录和输出目录
TMPDir="$workfile/tmp/"
DistDir="$workfile/dist/"
payload_img_dir="${TMPDir}payload_img/"
pre_patch_file_dir="${TMPDir}pre_patch_file/"
patch_mods_dir="${TMPDir}patch_mods/"
release_dir="${TMPDir}release/"

# 参数初始化
input_rom_version=""
input_rom_url=""
input_android_target_version="15"  # 默认值

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
    *)
      echo "❌ 未知参数: $1"
      exit 1
      ;;
  esac
done

# 检查必须参数
if [[ -z "$input_rom_version" || -z "$input_rom_url" ]]; then
  echo "❌ 错误：必须提供 --rom 和 --url 参数。" >&2
  echo "用法：bash ./build.sh --rom <ROM_VERSION> --url <ROM_URL> [--android <ANDROID_VERSION>]" >&2
  exit 1
fi

echo "🧹 清理并准备临时目录..."
rm -rf "$TMPDir"
mkdir -p "$TMPDir" "$DistDir" "$payload_img_dir" "$pre_patch_file_dir" "$patch_mods_dir" "$release_dir"

echo "🔍 检查 payload_dumper 是否可用..."
if ! command -v payload_dumper >/dev/null 2>&1; then
  echo "❌ 错误：payload_dumper 未安装或不在 PATH 中。" >&2
  echo "请安装它，例如：" >&2
  echo "  pipx install git+https://github.com/5ec1cff/payload-dumper" >&2
  exit 1
fi

echo "⬇️ 获取 system_ext.img..."
payload_dumper --partitions system_ext --out "$payload_img_dir" "$input_rom_url"

if [ ! -f "${payload_img_dir}system_ext.img" ]; then
  echo "❌ 找不到 system_ext.img" >&2
  exit 1
fi

echo "📦 解包 system_ext.img..."
$ExtractErofs -i "${payload_img_dir}system_ext.img" \
  -X "framework/miui-services.jar" \
  -X "priv-app/MiuiSystemUI/MiuiSystemUI.apk" \
  -o "$pre_patch_file_dir"

# 检查提取文件
required_files=(
  "system_ext/framework/miui-services.jar"
  "system_ext/priv-app/MiuiSystemUI/MiuiSystemUI.apk"
)

echo "✅ 校验解包文件是否提取成功..."
for file in "${required_files[@]}"; do
  if [ ! -f "${pre_patch_file_dir}${file}" ]; then
    echo "❌ 缺失文件: ${file}" >&2
    exit 1
  fi
done

echo "📁 复制补丁模组源码..."
cp -a "$workfile/mods/." "$patch_mods_dir"

echo "🛠️ 修补 miui-services.jar..."
cp -f "${pre_patch_file_dir}system_ext/framework/miui-services.jar" "${patch_mods_dir}/miui-services-Smali/miui-services.jar"
bash "${patch_mods_dir}/miui-services-Smali/run.sh" "$input_android_target_version"

echo "🛠️ 修补 MiuiSystemUI.apk..."
cp -f "${pre_patch_file_dir}system_ext/priv-app/MiuiSystemUI/MiuiSystemUI.apk" "${patch_mods_dir}/MiuiSystemUISmali/MiuiSystemUI.apk"
bash "${patch_mods_dir}/MiuiSystemUISmali/run.sh" "$input_android_target_version"

patched_files=(
  "miui-services-Smali/miui-services_out.jar"
  "MiuiSystemUISmali/MiuiSystemUI_out.apk"
)

echo "✅ 校验修补结果..."
for file in "${patched_files[@]}"; do
  if [ ! -f "${patch_mods_dir}${file}" ]; then
    echo "❌ 缺失补丁结果文件: ${file}" >&2
    exit 1
  fi
done

echo "📦 构建最终模块目录..."
cp -a "$workfile/module_src/." "$release_dir"

mkdir -p "${release_dir}system/system_ext/framework/"
cp -f "${patch_mods_dir}miui-services-Smali/miui-services_out.jar" "${release_dir}system/system_ext/framework/miui-services.jar"

mkdir -p "${release_dir}system/system_ext/priv-app/MiuiSystemUI/"
cp -f "${patch_mods_dir}MiuiSystemUISmali/MiuiSystemUI_out.apk" "${release_dir}system/system_ext/priv-app/MiuiSystemUI/MiuiSystemUI.apk"

echo "📝 更新 module.prop 中的版本号..."
sed -i "s/^version=.*/version=${input_rom_version}/" "${release_dir}module.prop"

final_zip="${DistDir}${input_rom_version}.zip"
echo "📦 打包为 Magisk 模块：$final_zip"
cd "$release_dir"
zip -r "$final_zip" ./*
cd "$workfile"

echo "✅ 构建完成：$final_zip"
