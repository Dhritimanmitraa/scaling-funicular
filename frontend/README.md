# Gyan AI - Flutter App

Gyan AI is an AI-powered learning companion designed to make education accessible, engaging, and personalized for students in India. This Flutter application provides the mobile interface for the Gyan AI platform.

## Features

- **User Authentication**: Email/password registration and login
- **Curriculum Selection**: Support for CBSE, ICSE, and State boards (Classes 5-10)
- **AI-Generated Content**: Video lessons and quizzes powered by AI
- **Progress Tracking**: Points system and daily streak tracking
- **Clean UI/UX**: Modern, accessible design following Material Design principles

## Architecture

This app follows Clean Architecture principles with:

- **Domain Layer**: Business logic and entities
- **Data Layer**: Repository implementations and data sources
- **Presentation Layer**: UI components and state management with BLoC

## Project Structure

```
lib/
├── src/
│   ├── app.dart                    # Main app widget
│   ├── core/                       # Shared components
│   │   ├── constants/              # App constants and routes
│   │   ├── errors/                 # Error handling
│   │   ├── models/                 # Data models
│   │   ├── network/                # API client
│   │   ├── router/                 # Navigation configuration
│   │   ├── services/               # Core services   
│   │   ├── theme/                  # App theme and styling
│   │   ├── utils/                  # Utility functions
│   │   └── widgets/                # Reusable widgets
│   └── features/                   # Feature-based modules
│       ├── auth/                   # Authentication
│       ├── curriculum/             # Curriculum browsing
│       ├── content/                # Video and quiz content
│       ├── home/                   # Dashboard
│       └── profile/                # User profile
```

## Getting Started

### Prerequisites

- Flutter 3.16.0 or higher
- Dart 3.2.0 or higher
- Android Studio / VS Code
- Android SDK (for Android development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Gyan-Ai/frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   - Copy `env.local` and update with your API keys and endpoints:
   ```
   API_BASE_URL=your_backend_url
   OPENROUTER_API_KEY=your_openrouter_key
   FAL_AI_API_KEY=your_fal_ai_key
   FIREBASE_API_KEY=your_firebase_key
   SENTRY_DSN=your_sentry_dsn
   ```

4. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Configuration

### API Integration

The app is configured to work with the Gyan AI backend API. Update the `API_BASE_URL` in `env.local` to point to your backend server.

### Firebase Setup

1. Create a Firebase project
2. Add your Android app to the project
3. Download `google-services.json` and place it in `android/app/`
4. Update Firebase configuration in `env.local`

### Sentry Setup

For error reporting and monitoring:

1. Create a Sentry project
2. Add your DSN to `env.local`
3. Sentry will automatically capture errors and performance data

## Dependencies

### Core Dependencies

- **flutter_bloc**: State management
- **go_router**: Navigation and routing
- **dio**: HTTP client for API calls
- **dartz**: Functional programming (Either type)
- **get_it**: Dependency injection
- **flutter_secure_storage**: Secure local storage
- **shared_preferences**: Local preferences storage

### UI Dependencies

- **cupertino_icons**: iOS-style icons
- **flutter_svg**: SVG image support

### Media Dependencies

- **video_player**: Video playback
- **chewie**: Enhanced video player

### Utilities

- **connectivity_plus**: Network connectivity
- **flutter_dotenv**: Environment variables
- **intl**: Internationalization
- **uuid**: UUID generation

### Analytics & Monitoring

- **firebase_analytics**: User analytics
- **sentry_flutter**: Error reporting and performance monitoring

## Development

### Code Generation

The app uses code generation for JSON serialization and other boilerplate code:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Testing

Run tests with:

```bash
flutter test
```

### Building

For Android:

```bash
flutter build apk --release
```

For Android App Bundle:

```bash
flutter build appbundle --release
```

## Features Implementation Status

### ✅ Completed
- Project structure and architecture
- Authentication screens (login, register, curriculum selection)
- Core services and networking
- Theme and styling system
- Navigation and routing
- Dashboard screen
- Error handling and loading states
- Basic gamification elements

### 🚧 In Progress / To Be Implemented
- Video player integration with AI-generated content
- Quiz functionality with AI-generated questions
- Complete curriculum browsing (subjects, chapters)
- Content generation API integration
- User progress tracking
- Push notifications
- Advanced gamification features

## Contributing

1. Follow the established architecture patterns
2. Use BLoC for state management
3. Implement proper error handling
4. Add appropriate tests for new features
5. Follow the existing code style and naming conventions

## Environment Variables

Required environment variables in `env.local`:

```env
# API Configuration
API_BASE_URL=http://localhost:3000/api
OPENROUTER_API_KEY=your_openrouter_api_key_here
FAL_AI_API_KEY=your_fal_ai_api_key_here

# Database Configuration
NEON_DATABASE_URL=your_neon_database_url_here

# Cloud Storage
CLOUD_STORAGE_BUCKET=your_cloud_storage_bucket_here
CLOUD_STORAGE_API_KEY=your_cloud_storage_api_key_here

# Firebase Configuration
FIREBASE_API_KEY=your_firebase_api_key_here
FIREBASE_PROJECT_ID=your_firebase_project_id_here
FIREBASE_APP_ID=your_firebase_app_id_here

# Sentry Configuration
SENTRY_DSN=your_sentry_dsn_here

# Environment
ENVIRONMENT=development
```

## License

This project is part of the Gyan AI platform. All rights reserved.

## Support

For support and questions, please refer to the project documentation or contact the development team.
