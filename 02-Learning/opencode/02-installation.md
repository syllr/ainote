# 安装 OpenCode

## 快速安装

安装 OpenCode 最简单的方法是通过安装脚本。

```bash
curl -fsSL https://opencode.ai/install | bash
```

## 使用包管理器安装

### Node.js

- npm
- Bun
- pnpm
- Yarn

```bash
npm install -g opencode-ai
```

### macOS 和 Linux (Homebrew)

```bash
brew install anomalyco/tap/opencode
```

> 我们推荐使用 OpenCode tap 以获取最新版本。官方的 `brew install opencode` formula 由 Homebrew 团队维护，更新频率较低。

### Arch Linux

```bash
sudo pacman -S opencode           # Arch Linux (Stable)
paru -S opencode-bin              # Arch Linux (Latest from AUR)
```

### Windows

推荐：使用 WSL

为了在 Windows 上获得最佳体验，我们推荐使用 [Windows Subsystem for Linux (WSL)](/docs/windows-wsl)。它提供更好的性能，并完全兼容 OpenCode 的所有功能。

- **使用 Chocolatey**
  ```bash
  choco install opencode
  ```

- **使用 Scoop**
  ```bash
  scoop install opencode
  ```

- **使用 NPM**
  ```bash
  npm install -g opencode-ai
  ```

- **使用 Mise**
  ```bash
  mise use -g github:anomalyco/opencode
  ```

- **使用 Docker**
  ```bash
  docker run -it --rm ghcr.io/anomalyco/opencode
  ```

在 Windows 上通过 Bun 安装 OpenCode 的支持目前正在开发中。

你也可以从 [Releases](https://github.com/anomalyco/opencode/releases) 页面直接下载二进制文件。
