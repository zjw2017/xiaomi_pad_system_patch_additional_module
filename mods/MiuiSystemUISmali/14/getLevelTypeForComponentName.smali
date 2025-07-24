
.method public getLevelType(Landroid/content/ComponentName;)I
    .locals 3

    if-eqz p1, :cond_2

    .line 1
    invoke-static {}, Lcom/android/wm/shell/multitasking/stubs/miuidesktopmode/MiuiDesktopModeStatus;->isActive()Z

    move-result v0

## patch start ##

    invoke-static {}, Lcom/android/wm/shell/miuifreeform/MiuiInfinityModeSizeLevelConfig;->getCvwFullDefaultDesktopEnabled()Z

    move-result v2

    if-eqz v2, :end

    const/4 v0, 0x1
    
:end

## patch end ##

    if-nez v0, :cond_0

    goto :goto_0

    .line 2
    :cond_0
    invoke-virtual {p1}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object v0

    .line 3
    invoke-virtual {p0, v0}, Lcom/android/wm/shell/miuifreeform/MiuiInfinityModeSizeLevelConfig;->isApplicationSupportCVW(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 4
    invoke-virtual {p0, p1}, Lcom/android/wm/shell/miuifreeform/MiuiInfinityModeSizeLevelConfig;->getActivityCVWLevel(Landroid/content/ComponentName;)I

    move-result p0

    .line 5
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "getActivityCVWLevel level="

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " activity="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "MiuiInfinityModeSizeLevelConfig"

    invoke-static {v0, p1}, Lcom/android/wm/shell/miuifreeform/MiuiInfinityModeController$Slog;->d(Ljava/lang/String;Ljava/lang/String;)V

    return p0

    .line 6
    :cond_1
    invoke-virtual {p0, v0}, Lcom/android/wm/shell/miuifreeform/MiuiInfinityModeSizeLevelConfig;->getLevelType(Ljava/lang/String;)I

    move-result p0

    return p0

    :cond_2
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

