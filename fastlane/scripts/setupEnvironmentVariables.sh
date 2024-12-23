echo "☁️  Environmant Variable Script Running..."

cd ..

ENVIRONMENT_FILE=".env.default.sample"

if [ -f ".env.default.sample" ]; then
    rm ".env.default.sample"
    echo "🗑️  Removing Existing Environment Variables"
fi

# Create The Default Environment Configuration
cat > "$ENVIRONMENT_FILE" << 'EOF'
#-----------------------------------------------------
# Twinkl Environment Configuration
# Copyright Twinkl Limited 2004
# Created By Josh Robbins (∩｀-´)⊃━☆ﾟ.*･｡ﾟ
#-----------------------------------------------------

# The Name Of The Workspace
WORKSPACE = ""

# The Name Of The Project"
PROJECT_NAME = ""

# The Name Of The Repository Prefixed By The Corresponding Github Account/UserName
REPOSITORY_NAME = ""

# The Name Of The Main Scheme In Xcode
SCHEME_NAME = ""

# The Name Of The Testing Scheme In Xcode
TEST_SCHEME_NAME = ""

#------------------------------
# XCODE Settings
# Improve Build Stability
#------------------------------

# Timeout Duration Used By Fastlane When Building The App
FASTLANE_XCODEBUILD_SETTINGS_TIMEOUT=1800

# Timeout Duration Used By Fastlane When Building The App
FASTLANE_XCODEBUILD_SETTINGS_RETRIES=5

#-------------------------------------------------------------------------
# Authorization
#-------------------------------------------------------------------------

# All Devs should be using SSH to authenticate so this shouldn't be needed
# MATCH_GIT_BASIC_AUTHORIZATION= ""

# Everyone must have this to be able to sync our certificates.
# MATCH_PASSWORD= ""

# This Is For Admin User When Creating Certificates.
# MATCH_USERNAME= ""

#-------------------------------------------------------------------
# AppStore Connect API
# Required Credentials For Uploading To AppStore Via Terminal Not CI
# These are our GithubSecrets
#-------------------------------------------------------------------

# APP_STORE_CONNECT_API_KEY_ID= ""
# APP_STORE_CONNECT_API_ISSUER_ID= ""
# APP_STORE_CONNECT_API_KEY_CONTENT= ""

# Can Be Any PAT With Read/Write Access To The Repositories
# IOS_GIT_AUTHORIZATION_FOR_WORKFLOWS = ""

#-------------------------------------------------------------------
# GoogleChat Webhook
# Required For Posting Messages To Our GoogleChat
#-------------------------------------------------------------------

IOS_TEAM_CHAT_CI_WEBHOOK = ""

EOF

echo "🫠  Environment Variables Configured  🫠"
