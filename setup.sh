#!/bin/bash

echo "Starting project setup..."

# Install Mint
if command -v mint >/dev/null; then
    echo "Bootstrapping Mint packages..."
    mint bootstrap || { echo "Error: Failed to install Mint dependencies"; exit 2; }
else
    echo "Error: Mint is not installed. Please install Mint (https://github.com/yonaskolb/Mint)."
    exit 1
fi

# Generate Xcode project
echo "Generating Xcode project..."
mint run xcodegen || { echo "Error: Cannot generate Xcode project"; exit 3; }

# Install Bundler
if command -v bundle >/dev/null; then
    echo "Bundler is already installed."
else
    echo "Installing Bundler..."
    gem install bundler || { echo "Error: Failed to install Bundler."; exit 4; }
fi

# Bundle install
if [ -f "Gemfile" ]; then
    echo "Installing Ruby gems..."
    bundle install || { echo "Error: Failed to run bundle install."; exit 5; }
else
    echo "Gemfile not found. Skipping bundle install."
fi

# Install CocoaPods
if [ -f "Podfile" ]; then
    echo "Installing CocoaPods dependencies..."
    bundle exec pod install || { echo "Error: Failed to install CocoaPods dependencies."; exit 6; }
else
    echo "Podfile not found. Skipping CocoaPods dependencies installation."
fi

echo "Project setup complete!"
