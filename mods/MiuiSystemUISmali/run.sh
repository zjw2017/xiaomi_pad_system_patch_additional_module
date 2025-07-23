#!/bin/bash
# shellcheck disable=SC2003,SC2046,SC2086,SC2162,SC2154,SC2155
android_target_version="$1"
workfile=${0%/*}
APKEditor="java -jar $workfile/../../../common/jar/APKEditor.jar"
$APKEditor d -f -i $workfile/MiuiSystemUI.apk -o $workfile/MiuiSystemUI

### 竖屏上下分屏
patch_VerticalSplit() {
    ### 竖屏上下分屏
    # 查找原函数位置
    local SplitScreenUtilsSmali=$(find $workfile/MiuiSystemUI/smali/*/com/android/wm/shell/common/split -type f -iname "SplitScreenUtils.smali")
    local start_line_isLeftRightSplitForZ=$(grep -n -m 1 ".method public static isLeftRightSplit(ZLandroid/content/res/Configuration;)Z" "$SplitScreenUtilsSmali" | cut -d: -f1)

    # 在start_line_isLeftRightSplitForZ的上一行插入新方法
    local insert_line_getVerticalSplitValue=$((start_line_isLeftRightSplitForZ - 1))
    sed -i "${insert_line_getVerticalSplitValue}r $workfile/getVerticalSplitValue.smali" "$SplitScreenUtilsSmali"

    # 从start_line_isLeftRightSplitForZ开始查找 "const/16 v1, 0x258"
    local start_line_isLeftRightSplitForZ=$(grep -n -m 1 ".method public static isLeftRightSplit(ZLandroid/content/res/Configuration;)Z" "$SplitScreenUtilsSmali" | cut -d: -f1)
    local find_line_isLeftRightSplitForZ_relative_v1_const=$(tail -n +"$start_line_isLeftRightSplitForZ" "$SplitScreenUtilsSmali" | grep -n -m 1 "const/16 v1, 0x258" | cut -d: -f1)
    local end_line_isLeftRightSplitForZ_v1_const=$((start_line_isLeftRightSplitForZ + find_line_isLeftRightSplitForZ_relative_v1_const - 1))

    # 删除end_line那一行
    sed -i "${end_line_isLeftRightSplitForZ_v1_const}d" "$SplitScreenUtilsSmali"
    # 在end_line原来的位置插入Insert_getVerticalSplitValue_Func.smali
    sed -i "${end_line_isLeftRightSplitForZ_v1_const}r $workfile/Insert_getVerticalSplitValue_Func.smali" "$SplitScreenUtilsSmali"

    echo '修补verticalSplit完成'
}



### 所有应用支持无极小窗
patch_CvwFull() {

    local MiuiInfinityModeSizeLevelConfigSmali=$(find $workfile/MiuiSystemUI/smali/*/com/android/wm/shell/multitasking/miuiinfinitymode -type f -iname "MiuiInfinityModeSizeLevelConfig.smali")
    
    local getLevelTypeForString_start_line=$(grep -n -m 1 ".method public getLevelType(Ljava/lang/String;)I" "$MiuiInfinityModeSizeLevelConfigSmali" | cut -d: -f1)
    # 在getLevelTypeForString_start_line的上一行插入新方法-getCvwFull_Func
    local insert_getCvwFull_Func_line_to_MiuiInfinityModeSizeLevelConfigSmali=$((getLevelTypeForString_start_line - 1))
    sed -i "${insert_getCvwFull_Func_line_to_MiuiInfinityModeSizeLevelConfigSmali}r $workfile/getCvwFull_Func.smali" "$MiuiInfinityModeSizeLevelConfigSmali"

    # 重新查找getLevelTypeForString_start_line
    local getLevelTypeForString_start_line=$(grep -n -m 1 ".method public getLevelType(Ljava/lang/String;)I" "$MiuiInfinityModeSizeLevelConfigSmali" | cut -d: -f1)
    # 从getLevelTypeForString_start_line开始查找第一个.end method行号
    local getLevelTypeForString_end_line=$(tail -n +"$getLevelTypeForString_start_line" $MiuiInfinityModeSizeLevelConfigSmali | grep -n -m 1 ".end method" | cut -d: -f1)
    # 计算.end method的行号
    local actual_getLevelTypeForString_end_line=$((getLevelTypeForString_start_line + getLevelTypeForString_end_line - 1))
    # 删除原方法
    sed -i "${getLevelTypeForString_start_line},${actual_getLevelTypeForString_end_line}d" $MiuiInfinityModeSizeLevelConfigSmali
    # 插入Patch后的方法
    sed -i "$((getLevelTypeForString_start_line - 1))r $workfile/getLevelTypeForString.smali" $MiuiInfinityModeSizeLevelConfigSmali

    # 重新查找getLevelTypeForComponentName_start_line
    local getLevelTypeForComponentName_start_line=$(grep -n -m 1 ".method public getLevelType(Landroid/content/ComponentName;)I" "$MiuiInfinityModeSizeLevelConfigSmali" | cut -d: -f1)
    # 从getLevelTypeForComponentName_start_line开始查找第一个.end method行号
    local getLevelTypeForComponentName_end_line=$(tail -n +"$getLevelTypeForComponentName_start_line" $MiuiInfinityModeSizeLevelConfigSmali | grep -n -m 1 ".end method" | cut -d: -f1)
    # 计算.end method的行号
    local actual_getLevelTypeForComponentName_end_line=$((getLevelTypeForComponentName_start_line + getLevelTypeForComponentName_end_line - 1))
    # 删除原方法
    sed -i "${getLevelTypeForComponentName_start_line},${actual_getLevelTypeForComponentName_end_line}d" $MiuiInfinityModeSizeLevelConfigSmali
    # 插入Patch后的方法
    sed -i "$((getLevelTypeForComponentName_start_line - 1))r $workfile/getLevelTypeForComponentName.smali" $MiuiInfinityModeSizeLevelConfigSmali

    local MiuiInfinityModeLevelPolicyCompatSmali=$(find $workfile/MiuiSystemUI/smali/*/com/android/wm/shell/multitasking/miuiinfinitymode -type f -iname "MiuiInfinityModeLevelPolicyCompat.smali")

    local useNewLevelPolicyForString_start_line=$(grep -n -m 1 ".method public useNewLevelPolicy(Ljava/lang/String;)Z" "$MiuiInfinityModeLevelPolicyCompatSmali" | cut -d: -f1)
    # 在useNewLevelPolicyForString_start_line的上一行插入新方法-getCvwFull_Func
    local insert_getCvwFull_Func_line_to_MiuiInfinityModeLevelPolicyCompatSmali=$((useNewLevelPolicyForString_start_line - 1))
    sed -i "${insert_getCvwFull_Func_line_to_MiuiInfinityModeLevelPolicyCompatSmali}r $workfile/getCvwFull_Func.smali" "$MiuiInfinityModeLevelPolicyCompatSmali"

    # 重新查找useNewLevelPolicyForString_start_line
    local useNewLevelPolicyForString_start_line=$(grep -n -m 1 ".method public useNewLevelPolicy(Ljava/lang/String;)Z" "$MiuiInfinityModeLevelPolicyCompatSmali" | cut -d: -f1)
    # 从useNewLevelPolicyForString_start_line开始查找第一个.end method行号
    local useNewLevelPolicyForString_end_line=$(tail -n +"$useNewLevelPolicyForString_start_line" $MiuiInfinityModeLevelPolicyCompatSmali | grep -n -m 1 ".end method" | cut -d: -f1)
    # 计算.end method的行号
    local actual_useNewLevelPolicyForString_end_line=$((useNewLevelPolicyForString_start_line + useNewLevelPolicyForString_end_line - 1))
    # 删除原方法
    sed -i "${useNewLevelPolicyForString_start_line},${actual_useNewLevelPolicyForString_end_line}d" $MiuiInfinityModeLevelPolicyCompatSmali
    # 插入Patch后的方法
    sed -i "$((useNewLevelPolicyForString_start_line - 1))r $workfile/useNewLevelPolicyForString.smali" $MiuiInfinityModeLevelPolicyCompatSmali

    echo '修补CvwFull完成'
}

### 隐藏自由窗口小白条
patch_DisableFreeformBottomCaption() {

    local MiuiBottomDecorationSmali=$(find $workfile/MiuiSystemUI/smali/*/com/android/wm/shell/multitasking/miuimultiwinswitch/miuiwindowdecor -type f -iname "MiuiBottomDecoration.smali")
    
    # 查找createBottomCaption_start_line
    local createBottomCaption_start_line=$(grep -n -m 1 ".method private createBottomCaption()Lcom/android/wm/shell/multitasking/miuimultiwinswitch/miuiwindowdecor/MiuiBottomBarView;" "$MiuiBottomDecorationSmali" | cut -d: -f1)
    # 从createBottomCaption_start_line开始查找第一个.end method行号
    local createBottomCaption_end_line=$(tail -n +"$createBottomCaption_start_line" $MiuiBottomDecorationSmali | grep -n -m 1 ".end method" | cut -d: -f1)
    # 计算.end method的行号
    local actual_createBottomCaption_end_line=$((createBottomCaption_start_line + createBottomCaption_end_line - 1))
    # 删除原方法
    sed -i "${createBottomCaption_start_line},${actual_createBottomCaption_end_line}d" $MiuiBottomDecorationSmali
    # 插入Patch后的方法
    sed -i "$((createBottomCaption_start_line - 1))r $workfile/createBottomCaption.smali" $MiuiBottomDecorationSmali

    echo '修补隐藏自由窗口小白条完成'
}

### 沉浸自由窗口小白条
patch_ImmerseFreeformBottomCaption() {

    local MiuiBottomDecorationSmali=$(find $workfile/MiuiSystemUI/smali/*/com/android/wm/shell/multitasking/miuimultiwinswitch/miuiwindowdecor -type f -iname "MiuiBottomDecoration.smali")
    
    # 查找inBottomCaptionInsetsBlackList_start_line
    local inBottomCaptionInsetsBlackList_start_line=$(grep -n -m 1 ".method private inBottomCaptionInsetsBlackList()Z" "$MiuiBottomDecorationSmali" | cut -d: -f1)
    # 从createBottomCaption_start_line开始查找第一个.end method行号
    local inBottomCaptionInsetsBlackList_end_line=$(tail -n +"$inBottomCaptionInsetsBlackList_start_line" $MiuiBottomDecorationSmali | grep -n -m 1 ".end method" | cut -d: -f1)
    # 计算.end method的行号
    local actual_inBottomCaptionInsetsBlackList_end_line=$((inBottomCaptionInsetsBlackList_start_line + inBottomCaptionInsetsBlackList_end_line - 1))
    # 删除原方法
    sed -i "${inBottomCaptionInsetsBlackList_start_line},${actual_inBottomCaptionInsetsBlackList_end_line}d" $MiuiBottomDecorationSmali
    # 插入Patch后的方法
    sed -i "$((inBottomCaptionInsetsBlackList_start_line - 1))r $workfile/inBottomCaptionInsetsBlackList.smali" $MiuiBottomDecorationSmali

    echo '修补沉浸自由窗口小白条完成'
}


### 运行修补
patch_VerticalSplit
patch_CvwFull
patch_DisableFreeformBottomCaption
patch_ImmerseFreeformBottomCaption

### 兼容小米错误的资源数据-@style/null
sed -i 's/\s*parent="@style\/null"//g' $workfile/MiuiSystemUI/resources/*/res/values/styles.xml
sed -i 's/\s*parent="@style\/null"//g' $workfile/MiuiSystemUI/resources/*/res/values-night/styles.xml

$APKEditor b -f -i $workfile/MiuiSystemUI -o $workfile/MiuiSystemUI_out.apk
