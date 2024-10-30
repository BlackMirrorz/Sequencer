echo "☁️  Github Configuration Running..."

# Change Into The Parent Directory
cd ../..

# Create The Hooks Directory Or Replace If Needed
GIT_HOOKS_DIR=".git/hooks"
PRE_COMMIT_HOOK="$GIT_HOOKS_DIR/pre-commit"

mkdir -p "$GIT_HOOKS_DIR"
find "$GIT_HOOKS_DIR" -type f ! -name 'pre-commit' -delete

# Create The Pre-Commit File & Make It Exectuable
cat > "$PRE_COMMIT_HOOK" << 'EOF'
#!/bin/bash

echo "📁  Starting in Directory: $(pwd)"

# Get Path To Mint Binaries
echo '🛠️  Validating Mint Install'

if command -v mint &> /dev/null; then
    echo '✅  Mint is installed'
    
    # Directly add the known Mint binaries path
    mint_link_path="$HOME/.mint/bin"
    export PATH="$PATH:$mint_link_path"
    
    echo "✅  Mint Binaries Added To PATH: $mint_link_path"
else
    echo '❌  Mint is not installed' >&2
    exit 1
fi


echo "📁 Changed Directory to: $(pwd)"

# Set Paths For Swift Format & SwiftLint
swiftformat_config="fastlane/.swiftformat"
swiftlint_config="fastlane/.swiftlint.yml"

# Check if SwiftFormat Congig File Exists
if [[ ! -f $swiftformat_config ]]; then
    echo "❌  SwiftFormat Config File Not Found At: $swiftformat_config" >&2
    exit 1
fi


# Run Swift Format
echo '🛠️  Formatting Code'

if command -v swiftformat &> /dev/null; then
    swiftformat . --config "$swiftformat_config" || {
        echo '❌  SwiftFormat Failed To Complete!' >&2
        exit 1
    }
    echo '✅  SwiftFormat Completed Successfully.'
else
    echo '❌  SwiftFormat Not Installed' >&2
    exit 1
fi

# Check if SwiftLint Congig File Exists
if [[ ! -f $swiftlint_config ]]; then
    echo "❌  SwiftLint config file not found at: $swiftlint_config" >&2
    exit 1
fi

# Run Swift Lint
echo '🛠️  Linting Code'

if command -v swiftlint &> /dev/null; then
    swiftlint --config "$swiftlint_config" --fix && swiftlint --config "$swiftlint_config" || {
        echo '❌  SwiftLint Failed To Complete!' >&2
        exit 1
    }
    echo '✅  SwiftLint Completed Successfully.'
else
    echo '❌  SwiftLint is not installed' >&2
    exit 1
fi

echo '🫠  Pre Commit Validation Completed  ✅'
exit 0
EOF

# Make The Pre-Commit Hook Executable
chmod +x "$PRE_COMMIT_HOOK"

echo "🫠  Git Hook Succesfully Configured  🫠"

# Create Or Replace The Gitignore If Needed
echo "☁️  Create GitIgnore Running..."

GIT_IGNORE_SOURCE=".gitignore"

if [ -f ".gitignore" ]; then
    rm ".gitignore"
    echo "🗑️  Removing Existing GitIgnore File"
fi

cat > "$GIT_IGNORE_SOURCE" << 'EOF'
# Created by https://www.toptal.com/developers/gitignore/api/xcode,macos,swift
# Edit at https://www.toptal.com/developers/gitignore?templates=xcode,macos,swift

### Fastlane ###
fastlane/report.xml
fastlane/README.md
fastlane/test_output
packages_cache
.env.default
gc_keys.json

### macOS ###
# General
.DS_Store
.AppleDouble
.LSOverride

# Icon must end with two \r
Icon


# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

### macOS Patch ###
# iCloud generated files
*.icloud

### Swift ###
# Xcode
#
# gitignore contributors: remember to update Global/Xcode.gitignore, Objective-C.gitignore & Swift.gitignore

## User settings
xcuserdata/

## compatibility with Xcode 8 and earlier (ignoring not required starting Xcode 9)
*.xcscmblueprint
*.xccheckout

## compatibility with Xcode 3 and earlier (ignoring not required starting Xcode 4)
build/
DerivedData/
*.moved-aside
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3

## Obj-C/Swift specific
*.hmap

## App packaging
*.ipa
*.dSYM.zip
*.dSYM

## Playgrounds
timeline.xctimeline
playground.xcworkspace

# Swift Package Manager
# Add this line if you want to avoid checking in source code from Swift Package Manager dependencies.
# Packages/
# Package.pins
# Package.resolved
# *.xcodeproj
# Xcode automatically generates this directory with a .xcworkspacedata file and xcuserdata
# hence it is not needed unless you have added a package configuration file to your project
# .swiftpm

.build/

# CocoaPods
# We recommend against adding the Pods directory to your .gitignore. However
# you should judge for yourself, the pros and cons are mentioned at:
# https://guides.cocoapods.org/using/using-cocoapods.html#should-i-check-the-pods-directory-into-source-control
# Pods/
# Add this line if you want to avoid checking in source code from the Xcode workspace
# *.xcworkspace

# Carthage
# Add this line if you want to avoid checking in source code from Carthage dependencies.
# Carthage/Checkouts

Carthage/Build/

# Accio dependency management
Dependencies/
.accio/

# fastlane
# It is recommended to not store the screenshots in the git repo.
# Instead, use fastlane to re-generate the screenshots whenever they are needed.
# For more information about the recommended setup visit:
# https://docs.fastlane.tools/best-practices/source-control/#source-control

fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots/**/*.png
fastlane/test_output

# Code Injection
# After new code Injection tools there's a generated folder /iOSInjectionProject
# https://github.com/johnno1962/injectionforxcode

iOSInjectionProject/

### Xcode ###

## Xcode 8 and earlier

### Xcode Patch ###
*.xcodeproj/*
!*.xcodeproj/project.pbxproj
!*.xcodeproj/xcshareddata/
!*.xcodeproj/project.xcworkspace/
!*.xcworkspace/contents.xcworkspacedata
/*.gcno
**/xcshareddata/WorkspaceSettings.xcsettings

# End of https://www.toptal.com/developers/gitignore/api/xcode,macos,swift
EOF

echo "🫠  GitIgnore Succesfully Configured  🫠"

# Create Or Replace The Gitignore If Needed
echo "☁️  PR Template Generator Running..."

GIT_DIR=".github"

PR_TEMPLATE="pull_request_template.md"

if [ ! -d "$GIT_DIR" ]; then
    mkdir "$GIT_DIR"
    echo "📁  Creating $GIT_DIR directory"
fi

if [ -f "$GIT_DIR/$PR_TEMPLATE" ]; then
    rm "$GIT_DIR/$PR_TEMPLATE"
    echo "🗑️  Removing Existing PR Template"
fi

cat > "$GIT_DIR/$PR_TEMPLATE" << 'EOF'
### 🧠 Description of this Pull Request:
What's the context for this Pull Request?

### ⚙️ Changes being made (check all that are applicable):
- [ ] 🍕 Feature
- [ ] 🐛 Bug Fix
- [ ] 📝 Documentation Update
- [ ] 🎨 Style
- [ ] 🧑‍💻 Code Refactor
- [ ] 🔥 Performance Improvements
- [ ] ✅ Test
- [ ] 🤖 Build
- [ ] 🔁 CI
- [ ] 📦 Chore (Release)
- [ ] ⏩ Revert

### 🧪 Testing:
How do you know the changes are safe to ship to production?
What steps should the reviewer(s) take to test this PR?

### 📸 Screenshots/Videos (optional):
If you have made UI changes, what are the before and afters?

EOF
