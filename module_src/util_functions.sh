# shellcheck disable=SC2148

# 获取设备类型
check_device_type() {
  local redmi_pad_list=$1
  local device_code=$2
  local result="xiaomi"
  for i in $redmi_pad_list; do
    if [[ "$device_code" == "$i" ]]; then
      result=redmi
      break
    fi
  done
  echo $result
}

grep_prop() {
  local REGEX="s/^$1=//p"
  shift
  local FILES=$@
  [ -z "$FILES" ] && FILES='/system/build.prop'
  cat $FILES 2>/dev/null | dos2unix | sed -n "$REGEX" | head -n 1
}
