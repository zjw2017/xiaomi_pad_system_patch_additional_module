
.method public static getImmerseFreeformBottomCaptionEnabled()Z
    .registers 5

    .line 1
    invoke-static {}, Landroid/app/ActivityThread;->currentApplication()Landroid/app/Application;
    
    move-result-object v0

    if-eqz v0, :return_false

    const-string v1, "sothx_project_treble_immerse_freeform_bottom_caption_enable"

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v2

    const/4 v3, 0x0

    invoke-static {v2, v1, v3}, Landroid/provider/Settings$System;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I
    move-result v1

    if-eqz v1, :return_false

    const/4 v0, 0x1  # true
    return v0

:return_false
    const/4 v0, 0x0  # false
    return v0
.end method


.method private inBottomCaptionInsetsBlackList()Z
    .locals 1

    .line 0
    invoke-static {}, Lcom/android/wm/shell/multitasking/miuimultiwinswitch/miuiwindowdecor/MiuiBottomDecoration;->getImmerseFreeformBottomCaptionEnabled()Z
    move-result v0

    return v0
.end method

