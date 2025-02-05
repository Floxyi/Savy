#!/bin/sh

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

echo "${GREEN}[1/4] Configuring Git hooks...${RESET}"
git config core.hooksPath .hooks
chmod +x .hooks/pre-commit

echo "${GREEN}[2/4] Checking Homebrew...${RESET}"
if ! command -v brew >/dev/null 2>&1; then
    echo "${YELLOW}Homebrew is not installed. Installing Homebrew now...${RESET}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Verify Homebrew installation
    if ! command -v brew >/dev/null 2>&1; then
        echo "${RED}Homebrew installation failed. Please install it manually and rerun this script.${RESET}"
        exit 1
    fi
fi

echo "${GREEN}[3/4] Configuring SwiftFormat...${RESET}"
if ! command -v swiftformat >/dev/null 2>&1; then
    echo "${YELLOW}SwiftFormat is not installed. Installing it now...${RESET}"
    brew install swiftformat

    # Verify SwiftFormat installation
    if ! command -v swiftformat >/dev/null 2>&1; then
        echo "${RED}SwiftFormat installation failed. Please install it manually and rerun this script.${RESET}"
        exit 1
    fi
fi

echo "${GREEN}[4/4] Setup complete!${RESET}"
