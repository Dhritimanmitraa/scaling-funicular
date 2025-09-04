    # Gyan AI Flutter App - Setup Guide

This guide will help you set up and run the Gyan AI Flutter application.

## Prerequisites

### Required Software
- **Flutter SDK**: 3.16.0 or higher
- **Dart SDK**: 3.2.0 or higher (comes with Flutter)
- **Android Studio**: Latest version (for Android development)
- **VS Code**: Optional but recommended
- **Git**: For version control

### Android Development
- **Android SDK**: API level 21 (Android 5.0) or higher
- **Android SDK Build-Tools**: 34.0.0
- **Android Emulator** or physical Android device

## Installation Steps

### 1. Clone and Navigate
```bash
git clone <repository-url>
cd Gyan-Ai/frontend
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Environment Configuration

#### Copy Environment Template
```bash
cp env.local.template env.local
```

#### Update Environment Variables
Edit `env.local` with your actual values:

```env
# API Configuration
API_BASE_URL=http://localhost:3000/api
OPENROUTER_API_KEY=your_actual_openrouter_key
FAL_AI_API_KEY=your_actual_fal_ai_key

# Firebase Configuration
FIREBASE_API_KEY=your_actual_firebase_api_key
FIREBASE_PROJECT_ID=gyan-ai-app
FIREBASE_APP_ID=your_actual_firebase_app_id
FIREBASE_MESSAGING_SENDER_ID=your_actual_sender_id
FIREBASE_STORAGE_BUCKET=gyan-ai-app.appspot.com

# Sentry Configuration
SENTRY_DSN=your_actual_sentry_dsn

# Environment
ENVIRONMENT=development
```

### 4. Firebase Setup

#### Download Configuration
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create or select your project
3. Add Android app with package name: `com.gyanai.app`
4. Download `google-services.json`
5. Replace the placeholder file at `android/app/google-services.json`

### 5. Generate Code
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 6. Font Setup (Optional)

Download Poppins fonts from [Google Fonts](https://fonts.google.com/specimen/Poppins) and place in `assets/fonts/`:
- `Poppins-Regular.ttf`
- `Poppins-Medium.ttf`
- `Poppins-SemiBold.ttf`
- `Poppins-Bold.ttf`

### 7. Verify Setup
```bash
flutter doctor
flutter analyze
```

## Running the App

### Development Mode
```bash
flutter run
```

### Debug Mode (with hot reload)
```bash
flutter run --debug
```

### Release Mode
```bash
flutter run --release
```

### Specific Device
```bash
flutter devices
flutter run -d <device-id>
```

## Building for Production

### APK
```bash
flutter build apk --release
```

### App Bundle (Recommended for Play Store)
```bash
flutter build appbundle --release
```

## Troubleshooting

### Common Issues

#### 1. "Flutter command not found"
- Ensure Flutter is installed and added to PATH
- Run `flutter doctor` to verify installation

#### 2. "Gradle build failed"
- Clean and rebuild: `flutter clean && flutter pub get`
- Check Android SDK installation
- Verify `local.properties` paths

#### 3. "Firebase initialization failed"
- Verify `google-services.json` is correctly placed
- Check Firebase configuration in `env.local`
- Ensure Firebase project is active

#### 4. "Package not found" errors
- Run `flutter pub get`
- Try `flutter clean && flutter pub get`
- Check `pubspec.yaml` for version conflicts

#### 5. Code generation issues
- Run `flutter packages pub run build_runner clean`
- Then `flutter packages pub run build_runner build --delete-conflicting-outputs`

### Debug Commands

```bash
# Check Flutter installation
flutter doctor -v

# Analyze code for issues
flutter analyze

# Run tests
flutter test

# Check dependencies
flutter pub deps

# Clean build artifacts
flutter clean

# Verbose logging
flutter run --verbose
```

## Development Workflow

### 1. Code Changes
- Make changes to Dart files
- Hot reload automatically applies changes
- Use `r` in terminal for manual hot reload
- Use `R` for hot restart

### 2. Adding Dependencies
- Add to `pubspec.yaml`
- Run `flutter pub get`
- Import in Dart files

### 3. State Management
- Use BLoC pattern for state management
- Follow Clean Architecture principles
- Separate domain, data, and presentation layers

### 4. Testing
- Write unit tests in `test/`
- Write widget tests for UI components
- Use integration tests for user flows

## Project Structure Summary

```
frontend/
├── android/                 # Android-specific configuration
├── assets/                  # Images, fonts, animations
├── lib/
│   ├── main.dart           # App entry point
│   └── src/
│       ├── app.dart        # Main app widget
│       ├── core/           # Shared components
│       └── features/       # Feature modules
├── test/                   # Test files
├── pubspec.yaml           # Dependencies and configuration
└── env.local              # Environment variables
```

## Next Steps

1. Set up your backend API server
2. Configure Firebase project
3. Add actual API keys and endpoints
4. Test the complete flow
5. Add custom assets and branding
6. Implement additional features

## Support

- Check the main README.md for detailed documentation
- Review the codebase comments for implementation details
- Follow Flutter best practices and conventions