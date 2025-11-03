.PHONY: build run install clean uninstall

APP_NAME = RustySpaces
BUILD_DIR = .build/release
EXECUTABLE = $(BUILD_DIR)/$(APP_NAME)
APP_BUNDLE = $(APP_NAME).app
INSTALL_DIR = $(HOME)/Applications
INSTALLED_APP = $(INSTALL_DIR)/$(APP_BUNDLE)

build:
	swift build -c release

run: build
	$(EXECUTABLE)

install: build create-plist
	@mkdir -p $(INSTALL_DIR)
	@rm -rf $(INSTALLED_APP)
	@mkdir -p $(INSTALLED_APP)/Contents/MacOS
	@mkdir -p $(INSTALLED_APP)/Contents
	@cp $(EXECUTABLE) $(INSTALLED_APP)/Contents/MacOS/$(APP_NAME)
	@chmod +x $(INSTALLED_APP)/Contents/MacOS/$(APP_NAME)
	@cp .build/Info.plist $(INSTALLED_APP)/Contents/Info.plist
	@echo "✓ Installed to $(INSTALLED_APP)"

create-plist:
	@mkdir -p .build
	@echo '<?xml version="1.0" encoding="UTF-8"?>' > .build/Info.plist
	@echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> .build/Info.plist
	@echo '<plist version="1.0">' >> .build/Info.plist
	@echo '<dict>' >> .build/Info.plist
	@echo '	<key>CFBundleDevelopmentRegion</key>' >> .build/Info.plist
	@echo '	<string>en</string>' >> .build/Info.plist
	@echo '	<key>CFBundleExecutable</key>' >> .build/Info.plist
	@echo '	<string>$(APP_NAME)</string>' >> .build/Info.plist
	@echo '	<key>CFBundleIdentifier</key>' >> .build/Info.plist
	@echo '	<string>com.rustyspaces.app</string>' >> .build/Info.plist
	@echo '	<key>CFBundleInfoDictionaryVersion</key>' >> .build/Info.plist
	@echo '	<string>6.0</string>' >> .build/Info.plist
	@echo '	<key>CFBundleName</key>' >> .build/Info.plist
	@echo '	<string>$(APP_NAME)</string>' >> .build/Info.plist
	@echo '	<key>CFBundlePackageType</key>' >> .build/Info.plist
	@echo '	<string>APPL</string>' >> .build/Info.plist
	@echo '	<key>CFBundleShortVersionString</key>' >> .build/Info.plist
	@echo '	<string>1.0</string>' >> .build/Info.plist
	@echo '	<key>CFBundleVersion</key>' >> .build/Info.plist
	@echo '	<string>1</string>' >> .build/Info.plist
	@echo '	<key>LSMinimumSystemVersion</key>' >> .build/Info.plist
	@echo '	<string>10.13</string>' >> .build/Info.plist
	@echo '	<key>NSHighResolutionCapable</key>' >> .build/Info.plist
	@echo '	<true/>' >> .build/Info.plist
	@echo '	<key>NSPrincipalClass</key>' >> .build/Info.plist
	@echo '	<string>NSApplication</string>' >> .build/Info.plist
	@echo '</dict>' >> .build/Info.plist
	@echo '</plist>' >> .build/Info.plist

uninstall:
	@rm -rf $(INSTALLED_APP)
	@echo "✓ Uninstalled $(APP_NAME)"

clean:
	swift package clean
	@rm -rf $(INSTALLED_APP)
	@echo "✓ Cleaned build artifacts"

help:
	@echo "RustySpaces Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make build      - Build release binary"
	@echo "  make run        - Build and run the app"
	@echo "  make install    - Build and install to ~/Applications"
	@echo "  make uninstall  - Remove installed app"
	@echo "  make clean      - Clean build artifacts"
	@echo "  make help       - Show this help message"
