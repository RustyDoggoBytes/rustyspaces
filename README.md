# RustySpaces

A macOS menu bar app that displays your current space number from yabai.

## Requirements

- **yabai** - A tiling window manager for macOS
- **jq** - Command-line JSON processor

## Installation

### 1. Install yabai

Follow the [official yabai installation guide](https://github.com/koekeishiya/yabai/wiki/Installing-yabai).

### 2. Install jq

```bash
brew install jq
```

### 3. Build and run RustySpaces

```bash
make run
```

## Usage

Once running, the app will display your current space number in the menu bar. The display updates every 0.5 seconds as you switch between spaces.

Click the menu bar icon to access the quit option, or press `Cmd+Q`.

## Available Make Commands

- `make build` - Build release binary
- `make run` - Build and run the app
- `make install` - Build and install to ~/Applications
- `make uninstall` - Remove installed app
- `make clean` - Clean build artifacts
- `make help` - Show help message
