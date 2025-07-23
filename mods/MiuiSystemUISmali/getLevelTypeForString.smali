
.method public getLevelType(Ljava/lang/String;)I
    .locals 6

    .line 7
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p0

    const/4 v0, 0x0

    const-string v1, "MiuiInfinityModeSizeLevelConfig"

    if-nez p0, :cond_5

    invoke-static {}, Lcom/android/wm/shell/multitasking/stubs/miuidesktopmode/MiuiDesktopModeStatus;->isActive()Z

    move-result p0

## patch start ##

    invoke-static {}, Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeSizeLevelConfig;->getCvwFullDefaultDesktopEnabled()Z

    move-result v3

    if-eqz v3, :cvw_patch_1_end

    const/4 p0, 0x1
    
    :cvw_patch_1_end

## patch end ##

    if-nez p0, :cond_0

    goto :goto_1

    .line 8
    :cond_0
    sget-object p0, Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeSizeLevelConfig;->LIST_ABOUT_UNSUPPORT_CVW_LEVEL_FULL:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1

    .line 9
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v2, "getLevelType unsupport cvw2.0 leve full packageName="

    invoke-direct {p0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeController$Slog;->d(Ljava/lang/String;Ljava/lang/String;)V

    return v0

    .line 10
    :cond_1
    sget-object p0, Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeSizeLevelConfig;->LIST_ABOUT_SUPPORT_CVW_LEVEL_FULL:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

## patch start ##

    invoke-static {}, Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeSizeLevelConfig;->getCvwFullGlobalEnabled()Z
    move-result v4

    invoke-static {}, Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeSizeLevelConfig;->getCvwFullDefaultDesktopEnabled()Z
    move-result v5

    or-int/2addr v4, v5

    if-eqz v4, :cvw_patch_2_end

    const/4 p0, 0x1

    :cvw_patch_2_end

## patch end ##

    if-eqz p0, :cond_2

    .line 11
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "getLevelType support cvw2.0 leve full packageName="

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeController$Slog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x1

    goto :goto_0

    .line 12
    :cond_2
    sget-object p0, Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeSizeLevelConfig;->LIST_ABOUT_SUPPORT_CVW_LEVEL_VERTICAL:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_3

    .line 13
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "getLevelType support cvw2.0 leve vertical packageName="

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeController$Slog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x2

    goto :goto_0

    .line 14
    :cond_3
    sget-object p0, Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeSizeLevelConfig;->LIST_ABOUT_SUPPORT_CVW_LEVEL_HORIZONTAL:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_4

    .line 15
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "getLevelType support cvw2.0 leve horizontal packageName="

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeController$Slog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x3

    :cond_4
    :goto_0
    return v0

    .line 16
    :cond_5
    :goto_1
    const-string p0, "getLevelType packageName is empty or desktop mode unactive."

    invoke-static {v1, p0}, Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeController$Slog;->w(Ljava/lang/String;Ljava/lang/String;)V

    return v0
.end method

