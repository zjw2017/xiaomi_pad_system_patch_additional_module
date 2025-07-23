
.method public static getDisableFreeformBottomCaptionEnabled()Z
    .registers 5

    .line 1
    invoke-static {}, Landroid/app/ActivityThread;->currentApplication()Landroid/app/Application;
    
    move-result-object v0

    if-eqz v0, :return_false

    const-string v1, "sothx_project_treble_disable_freeform_bottom_caption_enable"

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


.method private createBottomCaption()Lcom/android/wm/shell/multitasking/miuimultiwinswitch/miuiwindowdecor/MiuiBottomBarView;
    .locals 5

### start patch
    invoke-static {}, Lcom/android/wm/shell/multitasking/miuimultiwinswitch/miuiwindowdecor/MiuiBottomDecoration;->getDisableFreeformBottomCaptionEnabled()Z
    move-result v3

    if-eqz v3, :continue_create

    const/4 v4, 0x0
    return-object v4

    :continue_create

### end patch

    .line 1
    new-instance v0, Lcom/android/wm/shell/multitasking/miuimultiwinswitch/miuiwindowdecor/MiuiBottomBarView;

    .line 2
    iget-object v1, p0, Lcom/android/wm/shell/multitasking/miuimultiwinswitch/miuiwindowdecor/MiuiBaseWindowDecoration;->mContext:Landroid/content/Context;

    .line 4
    invoke-direct {v0, v1}, Lcom/android/wm/shell/multitasking/miuimultiwinswitch/miuiwindowdecor/MiuiBottomBarView;-><init>(Landroid/content/Context;)V

    .line 6
    new-instance v1, Landroid/view/ViewGroup$LayoutParams;

    .line 9
    const/4 v2, -0x1

    .line 11
    invoke-direct {v1, v2, v2}, Landroid/view/ViewGroup$LayoutParams;-><init>(II)V

    .line 12
    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 15
    iget-object p0, p0, Lcom/android/wm/shell/multitasking/miuimultiwinswitch/miuiwindowdecor/MiuiBaseWindowDecoration;->mContext:Landroid/content/Context;

    .line 18
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    .line 20
    move-result-object p0

    .line 23
    const v1, 0x7f13097d    # @string/multiwin_bottomcaption 'Floating window action bar'

    .line 24
    invoke-virtual {p0, v1}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    .line 27
    move-result-object p0

    .line 30
    invoke-virtual {v0, p0}, Landroid/view/View;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 31
    return-object v0
    .line 34
.end method

