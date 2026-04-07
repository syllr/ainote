# 安装指南

## 下载 Zed

### macOS

通过 [下载页面](https://zed.dev/download) 获取最新的稳定版本。如果你想要预览版本，可以在 [发布页面](https://zed.dev/releases/preview) 找到。首次手动安装后，Zed 会定期检查安装更新。

也可以通过 Homebrew 安装 Zed 稳定版：

```sh
brew install --cask zed
```

以及 Zed 预览版：

```sh
brew install --cask zed@preview
```

### Windows

通过 [下载页面](https://zed.dev/download) 获取最新的稳定版本。如果你想要预览版本，可以在 [发布页面](https://zed.dev/releases/preview) 找到。首次手动安装后，Zed 会定期检查安装更新。

此外，可以使用 winget 安装 Zed：

```sh
winget install -e --id ZedIndustries.Zed
```

### Linux

对于大多数 Linux 用户，最简单的安装方式是通过安装脚本：

```sh
curl -f https://zed.dev/install.sh | sh
```

现在可以指定要安装的 **版本**，使用 `ZED_VERSION` 环境变量：

```sh
# 安装最新的稳定版本（默认）
curl -f https://zed.dev/install.sh | sh

# 安装特定版本
curl -f https://zed.dev/install.sh | ZED_VERSION=0.216.0 sh
```

要安装预览版（比稳定版提前约一周获得更新）：

```sh
curl -f https://zed.dev/install.sh | ZED_CHANNEL=preview sh
```

此脚本支持 `x86_64` 和 `AArch64`，以及常见的 Linux 发行版：Ubuntu、Arch、Debian、RedHat、CentOS、Fedora 等。

如果使用此安装脚本安装 Zed，可以通过运行 shell 命令 `zed --uninstall` 随时卸载。Shell 会提示你想要保留首选项还是删除它们。做出选择后，你应该会看到 Zed 已成功卸载的消息。

如果此脚本不能满足你的使用需求、运行 Zed 时遇到问题或卸载 Zed 时出现错误，请参阅我们的 [Linux 特定文档](linux.html)。

## 系统要求

### macOS

Zed 支持以下 macOS 版本：

| 版本 | 代号 | Apple 状态 | Zed 状态 |
|------|------|------------|----------|
| macOS 26.x | Tahoe | 支持 | 支持 |
| macOS 15.x | Sequoia | 支持 | 支持 |
| macOS 14.x | Sonoma | 支持 | 支持 |
| macOS 13.x | Ventura | 支持 | 支持 |
| macOS 12.x | Monterey | EOL 2024-09-16 | 支持 |
| macOS 11.x | Big Sur | EOL 2023-09-26 | 部分支持 |
| macOS 10.15.x | Catalina | EOL 2022-09-12 | 部分支持 |

标记为"部分支持"的 macOS 版本（Big Sur 和 Catalina）不支持通过 Zed 协作进行屏幕共享。这些功能使用 [LiveKit SDK](https://livekit.io)，它依赖于 [ScreenCaptureKit.framework](https://developer.apple.com/documentation/screencapturekit/)，该框架仅在 macOS 12 (Monterey) 及更高版本上可用。

#### Mac 硬件

Zed 支持满足上述 macOS 要求的 Intel (x86_64) 或 Apple (aarch64) 处理器的机器：

- MacBook Pro (2015 年早期及更新)
- MacBook Air (2015 年早期及更新)
- MacBook (2016 年早期及更新)
- Mac Mini (2014 年后期及更新)
- Mac Pro (2013 年后期或更新)
- iMac (2015 年后期及更新)
- iMac Pro (所有型号)
- Mac Studio (所有型号)

### Linux

Zed 支持 64 位 Intel/AMD (x86_64) 和 64 位 Arm (aarch64) 处理器。

Zed 需要 Vulkan 1.3 驱动程序和以下桌面门户：

- `org.freedesktop.portal.FileChooser`
- `org.freedesktop.portal.OpenURI`
- `org.freedesktop.portal.Secret` 或 `org.freedesktop.Secrets`

### Windows

Zed 支持以下 Windows 版本：

| 版本 | Zed 状态 |
|------|----------|
| Windows 11, version 22H2 及更高版本 | 支持 |
| Windows 10, version 1903 及更高版本 | 支持 |

运行 Zed 需要 64 位操作系统。

#### Windows 硬件

Zed 支持满足以下要求的 x64 (Intel、AMD) 或 Arm64 (Qualcomm) 处理器的机器：

- **图形**: 支持 DirectX 11 的 GPU（大多数 2012 年后的 PC）
- **驱动**: 当前 NVIDIA/AMD/Intel/Qualcomm 驱动程序（不是 Microsoft 基本显示适配器）

### FreeBSD

尚未作为官方下载提供。可以从 [源代码构建](development/freebsd.html)。

### Web

目前不支持。请参阅我们的 [平台支持问题](https://github.com/zed-industries/zed/issues/5391)。

## 更新和卸载

### 更新

- **macOS**: Zed 会定期检查更新
- **Linux**: 使用安装脚本安装的版本，可以通过 `zed --update` 更新
- **Windows**: Zed 会定期检查更新

### 卸载

- **macOS**: 从应用程序文件夹拖动到废纸篓，或使用 Homebrew：`brew uninstall --cask zed`
- **Linux**: 运行 `zed --uninstall`
- **Windows**: 通过控制面板或应用设置卸载

## 故障排除

如遇安装问题，请查看 [故障排除文档](troubleshooting.html)。
