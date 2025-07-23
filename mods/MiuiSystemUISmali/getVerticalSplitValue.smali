
.method public static getVerticalSplitValue()I
    .registers 5

    .line 1
    invoke-static {}, Landroid/app/ActivityThread;->currentApplication()Landroid/app/Application;
    move-result-object v0

    if-eqz v0, :not_enabled

    const-string v1, "sothx_project_treble_vertical_screen_split_enable"

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v2

    const/4 v3, 0x0

    invoke-static {v2, v1, v3}, Landroid/provider/Settings$System;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I
    move-result v1

    if-eqz v1, :not_enabled

    const/16 v0, 0x400
    goto :end

    :not_enabled
    const/16 v0, 0x258

    :end
    return v0
.end method



