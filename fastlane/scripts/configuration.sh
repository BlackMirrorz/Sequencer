#!/bin/bash

FASTLANE_DIR="fastlane"

# Define SwiftLint & SwiftFormat Versions

SWIFTFORMAT_VERSION="0.53.1"
SWIFTLINT_VERSION="0.54.0"

echo "☁️  Local Setup Running..."

# Check To See If Homebrew Is Installed
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
        echo "✅ Homebrew Updated Successfully."
    else
        echo "❌  Failed To Update Homebrew."
        exit 1
    fi
fi

# 🌿 Install Mint To Ensure That We Lock Our Versions Of SwiftLint And SwiftFormat
if ! command -v mint &> /dev/null; then
    echo "🔍 Mint Is Not Installed. Installing Mint..."
    if ! brew install mint; then
        echo "❌  Failed To Install Mint."
        exit 1
    fi
else
    echo "🌱  Mint Is Already Installed. Checking For Updates..."
    brew upgrade mint || echo "🆙 Mint Is Up To Date."
fi

# Create Mintfile If It Doesnt Exist
MINTFILE="Mintfile"
if [ ! -f "$MINTFILE" ]; then
    echo "Creating $MINTFILE..."
    echo "nicklockwood/SwiftFormat@$SWIFTFORMAT_VERSION" > $MINTFILE
    echo "realm/SwiftLint@$SWIFTLINT_VERSION" >> $MINTFILE
    echo "✅ $MINTFILE created successfully."
else
    echo "$MINTFILE already exists."
fi

# Check & Uninstall SwiftFormat If Incorrect Version
installed_swiftformat_version=$(mint list | grep "nicklockwood/SwiftFormat" | awk '{print $3}')
if [ "$installed_swiftformat_version" != "" ] && [ "$installed_swiftformat_version" != "$SWIFTFORMAT_VERSION" ]; then
    echo "🔄  Uninstalling SwiftFormat Version $installed_swiftformat_version..."
    mint uninstall nicklockwood/SwiftFormat
fi

# Check & Uninstall SwiftLint If Incorrect Version
installed_swiftlint_version=$(mint list | grep "realm/SwiftLint" | awk '{print $3}')
if [ "$installed_swiftlint_version" != "" ] && [ "$installed_swiftlint_version" != "$SWIFTLINT_VERSION" ]; then
    echo "🔄  Uninstalling SwiftLint Version $installed_swiftlint_version..."
    mint uninstall realm/SwiftLint
fi

# Install SwiftFormat Using Mint In Our Repository
echo "📦 Installing SwiftFormat Version $SWIFTFORMAT_VERSION..."
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

# Check and delete Gemfile.lock if it exists
if [ -f Gemfile.lock ]; then
    echo "🗑️  Gemfile.lock exists. Deleting it..."
    rm Gemfile.lock
    echo "✅  Gemfile.lock deleted successfully."
else
    echo "📄  Gemfile.lock does not exist. No action needed."
fi

# Check For Gemfile
if [ ! -f Gemfile ]; then
    echo "📝  Gemfile does not exist. Creating and adding content..."
    # Create Gemfile and add content
    cat <<EOF >Gemfile
source "https://rubygems.org"

gem "fastlane"
gem "mutex_m"
gem "abbrev"

plugins_path = File.join(File.dirname(__FILE__), '.', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)

EOF
    echo "✅  Gemfile created and content added successfully."
else
    echo "📄  Gemfile already exists. Skipping creation."
fi

# Add FastLane Plugins
echo "🔌 Adding FastLane Plugins..."
bundle exec fastlane add_plugin swiftformat || { echo "❌  Failed To Add Fastlane-Plugin-SwiftFormat."; exit 1; }
echo "✅  FastLane Plugins Added Successfully."

echo "Current directory is: $(pwd)"

cd scripts

# Make setup-git-hooks.sh Executable
echo "🔧  Making setup-git.sh Executable..."
chmod +x ./setup-git.sh

# Run The Script Setup-Git.sh
echo "🔨  Running The Script Setup-Git..."
if ./setup-git.sh; then
    echo "✅  Setup-Git.sh Executed Successfully."
else
    echo "❌  Failed To Run Setup-Git.sh."
    exit 1
fi

# Make setup-lintingAndFormatting.sh Executable
echo "🔧  Making setup-lintingAndFormatting.sh Executable..."
chmod +x ./lintingAndFormatting.sh

# Run The Script Setup-LintingAndFormatting.sh
echo "🔨  Running The Script Setup-LintingAndFormatting.sh..."
if ./lintingAndFormatting.sh; then
    echo "✅  Setup-LintingAndFormatting-SPM.sh Executed Successfully."
else
    echo "❌  Failed To Run Setup-LintingAndFormatting.sh..."
    exit 1
fi

# Make SetupEnvironmentVariables.sh Executable
echo "🔧  Making setupEnvironmentVariables.sh Executable..."
chmod +x ./setupEnvironmentVariables.sh

# Run The Script SetupEnvironmentVariables.sh
echo "🔨  Running The Script SetupEnvironmentVariablesSPM.sh..."
if ./setupEnvironmentVariables.sh; then
    echo "✅  SetupEnvironmentVariables Executed Successfully."
else
    echo "❌  Failed To Run SetupEnvironmentVariablesSPM.sh..."
    exit 1
fi
