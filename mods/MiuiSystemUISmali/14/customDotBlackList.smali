

.method public static loadDotBlackListFromJson()Ljava/util/Set;
    .registers 12

    new-instance v0, Ljava/util/HashSet;
    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    # 调用 getCustomDotBlackListEnabled()
    invoke-static {}, Lcom/android/wm/shell/miuimultiwinswitch/MiuiMultiWinSwitchConfig;->getCustomDotBlackListEnabled()Z
    move-result v1

    if-eqz v1, :use_default_path

    const-string v1, "/data/system/dot_black_list.json"
    goto :path_set

:use_default_path
    const-string v1, "/product/etc/dot_black_list.json"

:path_set
    new-instance v2, Ljava/io/File;
    invoke-direct {v2, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->exists()Z
    move-result v3

    const-string v4, "/data/system/dot_black_list.json"
    invoke-virtual {v1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v4

    # if-nez 语法必须带跳转标签，修正如下
    if-nez v4, :check_file_exists
    goto :check_file_exists

:check_file_exists
    if-nez v3, :file_exists

    const-string v1, "/product/etc/dot_black_list.json"
    new-instance v2, Ljava/io/File;
    invoke-direct {v2, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

:file_exists
    invoke-virtual {v2}, Ljava/io/File;->exists()Z
    move-result v3

    if-eqz v3, :return_result

    # 初始化流变量置空
    const/4 v3, 0x0
    const/4 v4, 0x0
    const/4 v5, 0x0

    :try_start
    new-instance v3, Ljava/io/FileInputStream;
    invoke-direct {v3, v2}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    new-instance v4, Ljava/io/InputStreamReader;
    invoke-direct {v4, v3}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    new-instance v5, Ljava/io/BufferedReader;
    invoke-direct {v5, v4}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

:read_loop
    invoke-virtual {v5}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v7
    if-eqz v7, :parse_json

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :read_loop

:parse_json
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7

    new-instance v2, Lorg/json/JSONArray;
    invoke-direct {v2, v7}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I
    move-result v7

    const/4 v8, 0x0

:loop_array
    if-ge v8, v7, :close_resources

    :try_inner
    invoke-virtual {v2, v8}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;
    move-result-object v9

    invoke-interface {v0, v9}, Ljava/util/Set;->add(Ljava/lang/Object;)Z
    :try_end_inner
    .catch Lorg/json/JSONException; {:try_inner .. :try_end_inner} :catch_single

:continue_loop
    add-int/lit8 v8, v8, 0x1
    goto :loop_array

:catch_single
    move-exception v10
    # 忽略单个 JSON 解析异常，继续循环
    goto :continue_loop

:close_resources
    invoke-virtual {v5}, Ljava/io/BufferedReader;->close()V
    invoke-virtual {v4}, Ljava/io/InputStreamReader;->close()V
    invoke-virtual {v3}, Ljava/io/FileInputStream;->close()V

    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all

    goto :return_result

:catch_all
    move-exception v1

    const-string v2, "DotBlackList"
    const-string v3, "Failed to load from JSON"

    invoke-static {v2, v3, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

:return_result
    return-object v0
.end method


.method public static getCustomDotBlackListEnabled()Z 
    .registers 5

    .line 1
    invoke-static {}, Landroid/app/ActivityThread;->currentApplication()Landroid/app/Application;
    move-result-object v0

    if-eqz v0, :return_false

    const-string v1, "sothx_project_treble_custom_dot_black_list_enable" 

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

.method public getDotBlackList()Ljava/util/Set;
    .registers 1

    invoke-static {}, Lcom/android/wm/shell/miuimultiwinswitch/MiuiMultiWinSwitchConfig;->loadDotBlackListFromJson()Ljava/util/Set;

    move-result-object p0

    return-object p0
.end method



