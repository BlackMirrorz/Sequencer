#!/bin/bash

FASTLANE_DIR="fastlane"

# Define SwiftLint & SwiftFormat Versions

SWIFTFORMAT_VERSION="0.53.1"
SWIFTLINT_VERSION="0.54.0"

echo "☁️ CI Setup Running..."

# 🚀 Check To See If Homebrew Is Installed
# If Not, We Install The Latest
# If It Is, Check We Have The Latest
if ! command -v brew &> /dev/null
then
    echo "🔍 Homebrew Not Installed. Installing Homebrew..."
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        echo "✅  Homebrew Installed Successfully."
    else
        echo "❌  Failed To Install Homebrew."
        exit 1
    fi
else
    echo "🍺  Homebrew Is Already Installed. Updating Homebrew..."
    if brew update; then
        echo "✅  Homebrew Updated Successfully."
    else
        echo "❌  Failed To Update Homebrew."
        exit 1
    fi
fi

# Install Mint To Ensure That We Lock Our Versions Of SwiftLint And SwiftFormat
if ! command -v mint &> /dev/null; then
    echo "🔍 Mint Is Not Installed. Installing Mint..."
    if ! brew install mint; then
        echo "❌  Failed To Install Mint."
        exit 1
    fi
else
    echo "🌱  Mint Is Already Installed. Checking For Updates..."
    brew upgrade mint || echo "🆙  Mint Is Up To Date."
fi

# Create Mintfile If Needed
MINTFILE="Mintfile"
if [ ! -f "$MINTFILE" ]; then
    echo "Creating $MINTFILE..."
    echo "nicklockwood/SwiftFormat@$SWIFTFORMAT_VERSION" > $MINTFILE
    echo "realm/SwiftLint@$SWIFTLINT_VERSION" >> $MINTFILE
    echo "✅  $MINTFILE created successfully."
else
    echo "$MINTFILE already exists."
fi

# Install SwiftFormat Using Mint In Our Repository
echo "📦  Installing SwiftFormat Version $SWIFTFORMAT_VERSION..."
if ! mint install nicklockwood/SwiftFormat@$SWIFTFORMAT_VERSION; then
    echo "❌  Failed To Install SwiftFormat."
    exit 1
else
    echo "✅  SwiftFormat Installed Successfully."
fi

# Install SwiftLint Using Mint In Our Repository
echo "📦 Installing SwiftLint Version $SWIFTLINT_VERSION..."
if ! mint install realm/SwiftLint@$SWIFTLINT_VERSION; then
    echo "❌  Failed To Install SwiftLint."
    exit 1
else
    echo "✅  SwiftLint Installed Successfully."
fi
