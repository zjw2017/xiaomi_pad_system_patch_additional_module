

.method public static getCvwFullGlobalEnabled()Z
    .registers 5

    .line 1
    invoke-static {}, Landroid/app/ActivityThread;->currentApplication()Landroid/app/Application;
    move-result-object v0

    if-eqz v0, :return_false

    const-string v1, "sothx_project_treble_cvw_full_global_enable"

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

.method public static getCvwFullDefaultDesktopEnabled()Z
    .registers 5

    .line 1
    invoke-static {}, Landroid/app/ActivityThread;->currentApplication()Landroid/app/Application;
    move-result-object v0

    if-eqz v0, :return_false

    const-string v1, "sothx_project_treble_cvw_full_default_desktop_enable"

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

