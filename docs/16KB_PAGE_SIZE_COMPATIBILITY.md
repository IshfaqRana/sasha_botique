# 16KB Page Size Compatibility for Google Play

This document outlines the implementation of 16KB page size support for Google Play policy compliance on Android 15+.

## Overview

Google Play requires apps to support 16KB page size for Android 15+ devices. This implementation ensures our Flutter app meets these requirements.

## Changes Made

### 1. Toolchain Upgrades

- **Android Gradle Plugin**: Updated to 8.5.1 (from 8.4.0)
- **Gradle**: Updated to 8.7 (from 8.6)
- **Compile SDK**: Set to 36 (Android 15)
- **Target SDK**: Set to 35 (Android 15)

### 2. Configuration Files Updated

#### `android/settings.gradle`
```gradle
id "com.android.application" version "8.5.1" apply false
```

#### `android/gradle/wrapper/gradle-wrapper.properties`
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.7-all.zip
```

#### `android/app/build.gradle`
```gradle
android {
    compileSdk = 36
    // ...
    defaultConfig {
        targetSdk = 35
        // ...
    }
}
```

### 3. Native Library Analysis

All native libraries (.so files) in the APK are properly aligned:
- **libapp.so**: 64KB alignment (0x10000) - Compatible
- **libflutter.so**: 64KB alignment (0x10000) - Compatible
- **libdatastore_shared_counter.so**: 16KB alignment (0x4000) - Compatible

## Verification

### Manual Testing

Run the compatibility check script:
```bash
./scripts/check_16kb_compatibility.sh
```

### Automated Testing

Run the CI test script:
```bash
./scripts/ci_16kb_test.sh
```

### 16KB Emulator Testing

To test on a 16KB page size emulator:

1. Install the 16KB system image:
```bash
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "system-images;android-35;google_apis_playstore_ps16k;arm64-v8a"
```

2. Create the emulator:
```bash
$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager create avd -n Android_15_16KB -k "system-images;android-35;google_apis_playstore_ps16k;arm64-v8a"
```

3. Start the emulator:
```bash
$ANDROID_HOME/emulator/emulator -avd Android_15_16KB
```

4. Verify page size:
```bash
adb shell getconf PAGE_SIZE
# Should return: 16384
```

## CI/CD Integration

### GitHub Actions

The workflow `.github/workflows/16kb-compatibility.yml` automatically:
- Checks build configuration
- Validates native library alignment
- Builds release APK
- Runs compatibility tests
- Comments on PRs with results

### Local Development

Before committing, run:
```bash
./scripts/check_16kb_compatibility.sh
```

## Compliance Status

✅ **FULLY COMPLIANT** with Google Play 16KB page size requirements:

- ✅ Android Gradle Plugin 8.5.1+ (Required: 8.5.1+)
- ✅ Compile SDK 36 (Required: 35+)
- ✅ Target SDK 35 (Required: 35+)
- ✅ Gradle 8.7 (Required: 8.7+)
- ✅ Native libraries properly aligned
- ✅ Automated testing in place

## Troubleshooting

### Build Issues

If you encounter build issues after the upgrade:

1. Clean the project:
```bash
flutter clean
cd android && ./gradlew clean && cd ..
```

2. Rebuild:
```bash
flutter build apk --release
```

### Native Library Issues

If native libraries show alignment issues:

1. Ensure you're using the latest Flutter version
2. Update all plugins to latest versions
3. Rebuild with clean cache

### Emulator Issues

If 16KB emulator doesn't work:

1. Ensure you have the correct system image installed
2. Check emulator hardware acceleration settings
3. Try creating a new AVD with different hardware profile

## References

- [Google Play 16KB Page Size Policy](https://developer.android.com/about/versions/15/behavior-changes-15#16kb-page-size)
- [Android 15 Behavior Changes](https://developer.android.com/about/versions/15/behavior-changes-15)
- [Flutter Android Build Configuration](https://docs.flutter.dev/deployment/android#reviewing-the-build-configuration)

## Support

For issues related to 16KB page size compatibility:
1. Check the automated test results
2. Review the compatibility check script output
3. Test on a 16KB emulator
4. Contact the development team if issues persist
