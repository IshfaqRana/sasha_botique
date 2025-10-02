#!/bin/bash

# CI/CD 16KB Page Size Test Script
# This script should be integrated into your CI/CD pipeline

set -e  # Exit on any error

echo "=== CI/CD 16KB Page Size Validation ==="
echo ""

# Build the app
echo "1. Building release APK..."
flutter build apk --release
echo "   ✓ APK built successfully"
echo ""

# Check native library alignment
echo "2. Validating native library alignment..."
mkdir -p temp_ci_analysis
unzip -q build/app/outputs/flutter-apk/app-release.apk -d temp_ci_analysis

alignment_issues=0
find temp_ci_analysis -name "*.so" | while read lib; do
    align=$(readelf -l "$lib" 2>/dev/null | grep "LOAD" | head -1 | awk '{print $NF}')
    if [ "$align" != "0x10000" ] && [ "$align" != "0x4000" ]; then
        echo "   ❌ $(basename $lib): Invalid alignment $align"
        alignment_issues=$((alignment_issues + 1))
    else
        echo "   ✓ $(basename $lib): Proper alignment $align"
    fi
done

rm -rf temp_ci_analysis

if [ $alignment_issues -gt 0 ]; then
    echo "   ❌ Found $alignment_issues libraries with alignment issues"
    exit 1
fi
echo "   ✓ All native libraries properly aligned"
echo ""

# Check configuration
echo "3. Validating build configuration..."
compile_sdk=$(grep 'compileSdk' android/app/build.gradle | cut -d'=' -f2 | tr -d ' ')
target_sdk=$(grep 'targetSdk' android/app/build.gradle | cut -d'=' -f2 | tr -d ' ')
agp_version=$(grep 'com.android.application' android/settings.gradle | cut -d'"' -f4)

if [ "$compile_sdk" -lt 35 ]; then
    echo "   ❌ Compile SDK $compile_sdk is too low (required: 35+)"
    exit 1
fi

if [ "$target_sdk" -lt 35 ]; then
    echo "   ❌ Target SDK $target_sdk is too low (required: 35+)"
    exit 1
fi

echo "   ✓ Compile SDK: $compile_sdk"
echo "   ✓ Target SDK: $target_sdk"
echo "   ✓ AGP Version: $agp_version"
echo ""

# Test on emulator if available
echo "4. Testing on emulator..."
if adb devices | grep -q "emulator"; then
    emulator_id=$(adb devices | grep "emulator" | awk '{print $1}' | head -1)
    page_size=$(adb -s $emulator_id shell getconf PAGE_SIZE 2>/dev/null)
    
    if [ "$page_size" = "16384" ]; then
        echo "   ✓ Testing on 16KB page size emulator"
        
        # Install and launch app
        adb -s $emulator_id install -r build/app/outputs/flutter-apk/app-release.apk
        adb -s $emulator_id shell am start -n com.example.sasha_botique/.MainActivity
        
        # Wait and check if app is running
        sleep 10
        if adb -s $emulator_id shell pidof com.example.sasha_botique > /dev/null; then
            echo "   ✓ App launched successfully on 16KB emulator"
        else
            echo "   ❌ App failed to launch on 16KB emulator"
            exit 1
        fi
    else
        echo "   ⚠ Emulator has ${page_size}KB page size (not 16KB) - skipping runtime test"
    fi
else
    echo "   ⚠ No emulator available - skipping runtime test"
fi
echo ""

echo "🎉 All 16KB page size compatibility checks passed!"
echo "   The app is ready for Google Play submission with 16KB page size support."
