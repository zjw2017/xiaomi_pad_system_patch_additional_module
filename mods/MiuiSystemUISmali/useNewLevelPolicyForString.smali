
.method public useNewLevelPolicy(Ljava/lang/String;)Z
    .locals 2

    .line 1
    invoke-static {}, Lcom/android/wm/shell/multitasking/stubs/miuidesktopmode/MiuiDesktopModeStatus;->isActive()Z

    .line 2
    move-result v0

## patch start ##

    invoke-static {}, Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeLevelPolicyCompat;->getCvwFullDefaultDesktopEnabled()Z

    move-result v1

    if-eqz v1, :end

    const/4 v0, 0x1
    
:end

## patch end ##

    .line 5
    if-eqz v0, :cond_0

    .line 6
    iget-object p0, p0, Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeLevelPolicyCompat;->mMiuiInfinityModeSizeLevelConfig:Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeSizeLevelConfig;

    .line 8
    invoke-virtual {p0, p1}, Lcom/android/wm/shell/multitasking/miuiinfinitymode/MiuiInfinityModeSizeLevelConfig;->inNewLevelPolicy(Ljava/lang/String;)Z

    .line 10
    move-result p0

    .line 13
    if-eqz p0, :cond_0

    .line 14
    const/4 p0, 0x1

    .line 16
    goto :goto_0

    .line 17
    :cond_0
    const/4 p0, 0x0

    .line 18
    :goto_0
    return p0
    .line 19
.end method

