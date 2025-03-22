cd /Users/andela1234/Documents/app
source .secrets

# Install dependencies
flutter pub get

# Setup keychain
security create-keychain -p "$KEYCHAIN_PASSWORD" ci-keychain
security default-keychain -s ci-keychain
security unlock-keychain -p "$KEYCHAIN_PASSWORD" ci-keychain
echo "$CERTIFICATE_BASE64" | base64 --decode > certificate.p12
security import certificate.p12 -k ci-keychain -P "$CERTIFICATE_PASSWORD" -T /usr/bin/codesign
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
echo "$PROVISIONING_PROFILE_BASE64" | base64 --decode > ~/Library/MobileDevice/Provisioning\ Profiles/com.popcart.africa.mobileprovision

# Build iOS
flutter build ipa --flavor=production --target=lib/app/main.prod.dart --verbose --no-codesign
cd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release -archivePath build/Runner.xcarchive archive \
  CODE_SIGN_STYLE="Manual" \
  CODE_SIGN_IDENTITY="Apple Distribution" \
  PROVISIONING_PROFILE="com.popcart.africa.vax" \
  DEVELOPMENT_TEAM="LB5YMG5W6W"
xcodebuild -exportArchive -archivePath build/Runner.xcarchive -exportPath build/ipa -exportOptionsPlist ExportOptions.plist

 gem install fastlane
 fastlane deliver --ipa "../build/ipa/Runner.ipa" --username "$APPLE_ID_USERNAME" --password "$APPLE_ID_PASSWORD" --skip_metadata true --skip_screenshots true
