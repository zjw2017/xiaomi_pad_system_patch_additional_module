

.method public static getMiuiDesktopModeMaxFreeformCount()I
    .registers 6

    .line 1
    invoke-static {}, Landroid/app/ActivityThread;->currentApplication()Landroid/app/Application;
    move-result-object v0

    if-eqz v0, :return_default

    const-string v1, "sothx_project_treble_miui_desktop_mode_max_freeform_count"

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v2

    const/4 v3, 0x4  # default = 4

    invoke-static {v2, v1, v3}, Landroid/provider/Settings$System;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I
    move-result v1

    const/16 v2, 0x8  # max = 8
    invoke-static {v1, v2}, Ljava/lang/Math;->min(II)I
    move-result v1

    invoke-static {v1, v3}, Ljava/lang/Math;->max(II)I
    move-result v0

    return v0

:return_default
    const/4 v0, 0x4
    return v0
.end method

.method public static getDefaultDesktopModeMaxFreeformCount()I
    .registers 6

    .line 1
    invoke-static {}, Landroid/app/ActivityThread;->currentApplication()Landroid/app/Application;
    move-result-object v0

    if-eqz v0, :return_default

    const-string v1, "sothx_project_treble_default_desktop_mode_max_freeform_count"

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v2

    const/4 v3, 0x2  # default = 2

    invoke-static {v2, v1, v3}, Landroid/provider/Settings$System;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I
    move-result v1

    const/16 v2, 0x8  # max = 8
    invoke-static {v1, v2}, Ljava/lang/Math;->min(II)I
    move-result v1

    invoke-static {v1, v3}, Ljava/lang/Math;->max(II)I
    move-result v0

    return v0

:return_default
    const/4 v0, 0x2
    return v0
.end method

.method public getMaxMiuiFreeFormStackCount(Ljava/lang/String;Lcom/android/server/wm/MiuiFreeFormActivityStack;)I
    .locals 2
    .param p1, "packageName"    # Ljava/lang/String;
    .param p2, "stack"          # Lcom/android/server/wm/MiuiFreeFormActivityStack;

    # v0 = this.mFreeFormManagerService.mActivityTaskManagerService.mContext
    iget-object v0, p0, Lcom/android/server/wm/MiuiFreeFormStackDisplayStrategy;->mFreeFormManagerService:Lcom/android/server/wm/MiuiFreeFormManagerService;
    iget-object v0, v0, Lcom/android/server/wm/MiuiFreeFormManagerService;->mActivityTaskManagerService:Lcom/android/server/wm/ActivityTaskManagerService;
    iget-object v0, v0, Lcom/android/server/wm/ActivityTaskManagerService;->mContext:Landroid/content/Context;

    # 兼容 isActive(Context) 和 isDesktopActive()
    invoke-static {v0}, Lcom/android/server/wm/MiuiDesktopModeUtils;->isActive(Landroid/content/Context;)Z
    move-result v1
    if-nez v1, :desktop_active

    invoke-static {}, Lcom/android/server/wm/MiuiDesktopModeUtils;->isDesktopActive()Z
    move-result v1
    if-eqz v1, :check_multi_support

    :desktop_active
    invoke-static {}, Lcom/android/server/wm/MiuiFreeFormStackDisplayStrategy;->getMiuiDesktopModeMaxFreeformCount()I
    move-result v0
    return v0

    :check_multi_support
    # if (!MiuiMultiWindowUtils.multiFreeFormSupported(context)) return 1;
    invoke-static {v0}, Landroid/util/MiuiMultiWindowUtils;->multiFreeFormSupported(Landroid/content/Context;)Z
    move-result v1
    if-nez v1, :check_stack_null

    const/4 v0, 0x1
    return v0

    :check_stack_null
    # if (stack == null) return 0;
    if-nez p2, :check_embedded_or_split

    const/4 v0, 0x0
    return v0

    :check_embedded_or_split
    # if (isInEmbeddedWindowingMode(stack) || isSplitScreenMode()) return 1;
    invoke-direct {p0, p2}, Lcom/android/server/wm/MiuiFreeFormStackDisplayStrategy;->isInEmbeddedWindowingMode(Lcom/android/server/wm/MiuiFreeFormActivityStack;)Z
    move-result v0
    if-nez v0, :return_1

    invoke-direct {p0}, Lcom/android/server/wm/MiuiFreeFormStackDisplayStrategy;->isSplitScreenMode()Z
    move-result v0
    if-eqz v0, :return_4

    :return_1
    const/4 v0, 0x1
    return v0

    :return_4
    invoke-static {}, Lcom/android/server/wm/MiuiFreeFormStackDisplayStrategy;->getDefaultDesktopModeMaxFreeformCount()I
    move-result v0
    return v0
.end method


