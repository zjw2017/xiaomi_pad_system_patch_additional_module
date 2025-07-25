# ✨ 小米平板系统增强附加模块 · 自动构建

本项目用于自动构建适用于 **小米平板的 Magisk 模块**，通过提取指定 ROM 自动生成 Magisk 模块。

📱 当前仅支持 **Android 15**，后续将适配 Android 14。

---

## 💡 模块功能说明

本模块专为小米平板设计，功能包括：

| 功能 | 说明 |
|------|------|
| 🪟 无极小窗 | 普通桌面 / 工作台 任意应用开启小窗 |
| ↕️ 强制上下分屏 | 实现竖屏上下分屏（非官方方法） |
| 🚫 禁用分屏黑名单 | 所有应用都可加入分屏 |
| 🔢 自定义小窗数量 | 普通桌面 / 工作台最多可设 8 个 |
| 🧊 隐藏小窗小白条 | 隐藏或沉浸小窗下方导航条 |

> ⚙️ **所有功能的开关均可在 Web UI【完美横屏应用计划 → 系统体验增强】中进行设置。**

---

## ⚠️ 使用须知：更新系统前请注意！

为避免系统更新后卡 MI，模块做了以下处理：

- 当系统检测到 **更新后的 ROM** 时，模块会 **自动禁用**；
- 自动禁用机制 **仅适用于小米官方 ROM**，对于 **第三方移植包** 无法保证生效；
- **强烈建议你在更新系统前**，手动卸载本模块以避免开机卡住；

> 🔄 **每次系统更新后都需要重新前往 GitHub Actions 构建新的模块！**

> 🛑 **请务必提前安装至少一个 Magisk 救砖模块或其他模块恢复工具，以防模块异常导致无法进入系统！**

---

## 🚀 快速开始：构建你的专属模块

### 1️⃣ Fork 本项目

点击右上角 **Fork**，将本项目复制到你的 GitHub 账号中。

![fork 仓库](https://github.com/user-attachments/assets/daf22cc1-8a39-412e-9847-00d6e7e2999d)

---

### 2️⃣ 打开 Actions 页面

进入你的仓库，点击上方的 **Actions** 标签页，选择左侧 `构建 Magisk 模块`。

![进入 Actions](https://github.com/user-attachments/assets/5cf97d1b-dbcf-4c5c-91ba-1cb79508a09c)

---

### 3️⃣ 填写构建参数，运行 workflow

点击右上角 **Run workflow**，填写以下参数启动构建：

| 参数名   | 示例                                          | 说明                       |
|----------|-----------------------------------------------|----------------------------|
| `rom`    | `OS2.0.202.0.VOZCNXM`                         | ROM 版本号                 |
| `url`    | `https://bigota.d.miui.com/xxx/miui_xxx.zip`  | 官方 ROM 下载链接         |
| `android`| `15`（可选）                                 | Android 版本，默认为 15   |

> 📥 ROM 下载推荐：[https://hyperos.fans/](https://hyperos.fans/)

![运行 workflow](https://github.com/user-attachments/assets/3549eee0-6355-4cda-b2c6-80939665ca0c)

---

### 4️⃣ 下载模块

构建完成后，在页面底部 **Artifacts** 区块中下载生成的模块 ZIP 文件。

![下载构建产物](https://github.com/user-attachments/assets/4ef789c0-2f44-49f3-ac1c-397cc37b2f05)

---

## 📁 模块使用说明

下载的 ZIP 文件为 Magisk 模块，使用方法如下：

- 打开 Magisk App → 模块 → 从本地安装
- 或通过 TWRP 等第三方 Recovery 刷入

⚙️ 安装后，打开 **完美横屏应用计划 Web UI**，进入【系统体验增强】，即可设置开启或关闭相关功能。

---

## ❓ 常见问题

**Q：ROM 下载链接从哪里获取？**  
A：请访问 [https://hyperos.fans/](https://hyperos.fans/) 搜索对应设备版本。

**Q：适用于哪些设备？**  
A：推荐用于小米平板系列（如小米平板 6 / 6 Pro），需已解锁 Bootloader 并安装 Magisk。

**Q：构建失败怎么办？**  
A：请检查 ROM 链接是否有效，或提交 Issue 获取帮助。

**Q：每次系统更新后都要重新构建吗？**  
A：✅ 是的，每次系统更新都需要重新运行 GitHub Actions 构建新的模块，确保兼容当前 ROM。

**Q：模块导致无法进入系统怎么办？**  
A：请在安装本模块前务必准备 **救砖方案**（如：启用 zrecovery、KSU Safe Mode 或 TWRP 模块管理），避免意外导致无法恢复系统。

---

## 🤝 贡献者

欢迎提交 PR 支持更多功能或适配新设备！

---

## 🛠 技术说明

- 使用 GitHub Actions 实现自动构建
- 基于 payload-dumper 提取官方 ROM
- Bash 自动生成模块结构

