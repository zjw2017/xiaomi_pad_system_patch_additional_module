

.method public inResizeBlackList(Ljava/lang/String;)Z
    .locals 1
    .param p1, "packageName"    # Ljava/lang/String;

    .line 852
    iget-object v0, p0, Lcom/android/server/wm/ActivityTaskManagerServiceImpl;->mResizeBlackList:Ljava/util/HashSet;

    invoke-virtual {v0, p1}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z

    move-result v0

### START PATCH ###

    invoke-static {}, Lcom/android/server/wm/ActivityTaskManagerServiceImpl;->getDisableResizeBlackListEnabled()Z

    move-result v1

    if-eqz v1, :end

    const/4 v0, 0x0
    
:end

### END PATCH ###

    return v0
.end method