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

## 🚀 快速开始：构建你的专属模块

### 1️⃣ Fork 本项目

点击右上角 **Fork**，将本项目复制到你的 GitHub 账号中。

![fork 仓库](https://user-images.githubusercontent.com/your-image-link/fork.png)

---

### 2️⃣ 打开 Actions 页面

进入你的仓库，点击上方的 **Actions** 标签页，选择左侧 `构建 Magisk 模块`。

![进入 Actions](https://user-images.githubusercontent.com/your-image-link/actions.png)

---

### 3️⃣ 填写构建参数，运行 workflow

点击右上角 **Run workflow**，填写以下参数启动构建：

| 参数名   | 示例                                          | 说明                       |
|----------|-----------------------------------------------|----------------------------|
| `rom`    | `OS2.0.202.0.VOZCNXM`                         | ROM 版本号                 |
| `url`    | `https://bigota.d.miui.com/xxx/miui_xxx.zip`  | 官方 ROM 下载链接         |
| `android`| `15`（可选）                                 | Android 版本，默认为 15   |

> 📥 ROM 下载推荐：[https://hyperos.fans/](https://hyperos.fans/)

![运行 workflow](https://user-images.githubusercontent.com/your-image-link/run-workflow.png)

---

### 4️⃣ 下载模块

构建完成后，在页面底部 **Artifacts** 区块中下载生成的模块 ZIP 文件。

![下载构建产物](https://user-images.githubusercontent.com/your-image-link/artifact-download.png)

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

---

## 🤝 贡献者

欢迎提交 PR 支持更多功能或适配新设备！

---

## 🛠 技术说明

- 使用 GitHub Actions 实现自动构建
- 基于 payload-dumper 提取官方 ROM
- Bash 自动生成模块结构

---
