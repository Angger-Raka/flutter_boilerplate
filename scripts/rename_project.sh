#!/bin/bash

# =====================================================
# Flutter Boilerplate Rename Script
# =====================================================
# Usage: ./scripts/rename_project.sh new_app_name com.yourcompany.newapp
# Example: ./scripts/rename_project.sh my_calculator com.example.mycalculator
# =====================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check arguments
if [ $# -lt 2 ]; then
    echo -e "${RED}Usage: ./scripts/rename_project.sh <new_app_name> <new_bundle_id>${NC}"
    echo -e "Example: ./scripts/rename_project.sh my_calculator com.example.mycalculator"
    exit 1
fi

NEW_NAME=$1
NEW_BUNDLE_ID=$2
OLD_NAME="flutter_boilerplate"
OLD_BUNDLE_ID="com.example.flutter_boilerplate"

echo -e "${YELLOW}🔄 Renaming project from '$OLD_NAME' to '$NEW_NAME'${NC}"
echo -e "${YELLOW}🔄 Changing bundle ID from '$OLD_BUNDLE_ID' to '$NEW_BUNDLE_ID'${NC}"
echo ""

# =====================================================
# 1. Rename in Dart files (package imports)
# =====================================================
echo -e "${GREEN}📦 Updating Dart package imports...${NC}"
find lib -name "*.dart" -type f -exec sed -i '' "s/package:$OLD_NAME/package:$NEW_NAME/g" {} \;
find test -name "*.dart" -type f -exec sed -i '' "s/package:$OLD_NAME/package:$NEW_NAME/g" {} \; 2>/dev/null || true

# =====================================================
# 2. Update pubspec.yaml
# =====================================================
echo -e "${GREEN}📄 Updating pubspec.yaml...${NC}"
sed -i '' "s/name: $OLD_NAME/name: $NEW_NAME/g" pubspec.yaml
sed -i '' "s/description: \"Flutter Boilerplate\"/description: \"$NEW_NAME\"/g" pubspec.yaml

# =====================================================
# 3. Update Android files
# =====================================================
echo -e "${GREEN}🤖 Updating Android configuration...${NC}"

# build.gradle.kts
sed -i '' "s/namespace = \"$OLD_BUNDLE_ID\"/namespace = \"$NEW_BUNDLE_ID\"/g" android/app/build.gradle.kts
sed -i '' "s/applicationId = \"$OLD_BUNDLE_ID\"/applicationId = \"$NEW_BUNDLE_ID\"/g" android/app/build.gradle.kts

# AndroidManifest.xml
sed -i '' "s/$OLD_BUNDLE_ID/$NEW_BUNDLE_ID/g" android/app/src/main/AndroidManifest.xml
sed -i '' "s/$OLD_BUNDLE_ID/$NEW_BUNDLE_ID/g" android/app/src/debug/AndroidManifest.xml 2>/dev/null || true
sed -i '' "s/$OLD_BUNDLE_ID/$NEW_BUNDLE_ID/g" android/app/src/profile/AndroidManifest.xml 2>/dev/null || true

# Rename Kotlin directory structure
OLD_PACKAGE_DIR="android/app/src/main/kotlin/com/example/flutter_boilerplate"
NEW_PACKAGE_DIR="android/app/src/main/kotlin/$(echo $NEW_BUNDLE_ID | tr '.' '/')"

if [ -d "$OLD_PACKAGE_DIR" ]; then
    mkdir -p "$NEW_PACKAGE_DIR"
    sed -i '' "s/package $OLD_BUNDLE_ID/package $NEW_BUNDLE_ID/g" "$OLD_PACKAGE_DIR/MainActivity.kt"
    mv "$OLD_PACKAGE_DIR/MainActivity.kt" "$NEW_PACKAGE_DIR/"
    rm -rf "android/app/src/main/kotlin/com/example/flutter_boilerplate"
    # Clean up empty directories
    find android/app/src/main/kotlin -type d -empty -delete 2>/dev/null || true
fi

# =====================================================
# 4. Update iOS files
# =====================================================
echo -e "${GREEN}🍎 Updating iOS configuration...${NC}"
sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = $OLD_BUNDLE_ID/PRODUCT_BUNDLE_IDENTIFIER = $NEW_BUNDLE_ID/g" ios/Runner.xcodeproj/project.pbxproj 2>/dev/null || true

# =====================================================
# 5. Update Web files
# =====================================================
echo -e "${GREEN}🌐 Updating Web configuration...${NC}"
sed -i '' "s/$OLD_NAME/$NEW_NAME/g" web/manifest.json 2>/dev/null || true
sed -i '' "s/$OLD_NAME/$NEW_NAME/g" web/index.html 2>/dev/null || true

# =====================================================
# 6. Update macOS files
# =====================================================
echo -e "${GREEN}💻 Updating macOS configuration...${NC}"
sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = $OLD_BUNDLE_ID/PRODUCT_BUNDLE_IDENTIFIER = $NEW_BUNDLE_ID/g" macos/Runner.xcodeproj/project.pbxproj 2>/dev/null || true
sed -i '' "s/$OLD_NAME/$NEW_NAME/g" macos/Runner/Configs/AppInfo.xcconfig 2>/dev/null || true

# =====================================================
# 7. Update Linux files
# =====================================================
echo -e "${GREEN}🐧 Updating Linux configuration...${NC}"
sed -i '' "s/$OLD_NAME/$NEW_NAME/g" linux/CMakeLists.txt 2>/dev/null || true
sed -i '' "s/$OLD_NAME/$NEW_NAME/g" linux/runner/my_application.cc 2>/dev/null || true

# =====================================================
# 8. Update Windows files
# =====================================================
echo -e "${GREEN}🪟 Updating Windows configuration...${NC}"
sed -i '' "s/$OLD_NAME/$NEW_NAME/g" windows/CMakeLists.txt 2>/dev/null || true
sed -i '' "s/$OLD_NAME/$NEW_NAME/g" windows/runner/Runner.rc 2>/dev/null || true
sed -i '' "s/$OLD_NAME/$NEW_NAME/g" windows/runner/main.cpp 2>/dev/null || true

# =====================================================
# 9. Update l10n generated files
# =====================================================
echo -e "${GREEN}🌍 Updating localization imports...${NC}"
find lib/l10n/generated -name "*.dart" -type f -exec sed -i '' "s/package:$OLD_NAME/package:$NEW_NAME/g" {} \; 2>/dev/null || true

# =====================================================
# 10. Clean and regenerate
# =====================================================
echo ""
echo -e "${GREEN}🧹 Cleaning project...${NC}"
flutter clean
flutter pub get

echo ""
echo -e "${GREEN}🔧 Regenerating code...${NC}"
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs

# =====================================================
# Done!
# =====================================================
echo ""
echo -e "${GREEN}✅ Project renamed successfully!${NC}"
echo ""
echo -e "Next steps:"
echo -e "  1. Update app icons in assets/"
echo -e "  2. Run: flutter run --flavor dev"
echo -e "  3. (iOS) Open Xcode and update signing team"
echo ""
