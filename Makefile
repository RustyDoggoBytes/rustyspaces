.PHONY: build run install clean uninstall

APP_NAME = RustySpaces
BUILD_DIR = .build/release
APP_BUNDLE = $(APP_NAME).app
INSTALL_DIR = $(HOME)/Applications
APPS_DIR = $(INSTALL_DIR)
INSTALLED_APP = $(INSTALL_DIR)/$(APP_BUNDLE)


build:
	swift build -c release

run: build
	./$(BUILD_DIR)/$(APP_NAME)

install: build
	@echo "Creating app bundle..."
	@mkdir -p $(APP_BUNDLE)/Contents/MacOS
	@cp $(BUILD_DIR)/$(APP_NAME) $(APP_BUNDLE)/Contents/MacOS/
	@echo "Installing to $(APPS_DIR)..."
	@mv $(APP_BUNDLE) $(APPS_DIR)/
	@echo "✓ $(APP_NAME) installed successfully!"
	@echo "Launch with: open $(APPS_DIR)/$(APP_BUNDLE)"

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(APP_BUNDLE)
	swift package clean
