# Gyan-Ai: AI-Powered Educational Platform

## 🎓 About

Gyan-Ai is a comprehensive AI-powered educational platform designed to revolutionize learning through personalized content delivery, interactive quizzes, and intelligent curriculum management. Built with Flutter for cross-platform compatibility, the app provides students with an engaging and adaptive learning experience.

## ✨ Key Features

- **📚 Smart Curriculum Management**: Dynamic curriculum selection based on educational boards, classes, and subjects
- **🎯 Interactive Learning**: Video lessons with integrated quizzes and progress tracking
- **🏆 Gamification**: Points system, daily streaks, and achievement tracking
- **👤 User Management**: Secure authentication with profile management
- **📱 Cross-Platform**: Native Android and web support with responsive design
- **🎨 Modern UI**: Clean, intuitive interface following Material Design principles

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.24.5 with Dart
- **State Management**: BLoC pattern with flutter_bloc
- **Navigation**: GoRouter for declarative routing
- **HTTP Client**: Dio for API communication
- **Local Storage**: SharedPreferences for data persistence
- **Architecture**: Clean Architecture with Domain, Data, and Presentation layers

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.24.5 or higher
- Dart SDK 3.5.4 or higher
- Android Studio (for Android development)
- Chrome browser (for web development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Dhritimanmitraa/scaling-funicular.git
cd scaling-funicular
```

2. Navigate to the frontend directory:
```bash
cd frontend
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the application:
```bash
# For web
flutter run -d chrome

# For Android (requires emulator or device)
flutter run -d emulator-5554
```

## 📱 Platform Support

- ✅ **Web**: Fully functional with Chrome, Edge, and other modern browsers
- ✅ **Android**: Native Android app with Material Design
- 🔄 **iOS**: Planned for future releases

## 🏗️ Project Structure

```
frontend/
├── lib/
│   ├── src/
│   │   ├── core/           # Core utilities, themes, and services
│   │   ├── features/       # Feature-based modules
│   │   │   ├── auth/       # Authentication module
│   │   │   ├── curriculum/ # Curriculum management
│   │   │   ├── content/    # Learning content and quizzes
│   │   │   └── home/       # Dashboard and navigation
│   │   └── app.dart        # Main application entry point
│   └── main.dart           # Application bootstrap
├── android/                # Android-specific configuration
└── pubspec.yaml           # Dependencies and project metadata
```

## 🎨 Design System

The app follows a consistent design system with:
- **Primary Colors**: Modern blue and green palette
- **Typography**: Poppins font family for readability
- **Components**: Reusable UI components with consistent styling
- **Responsive Design**: Adaptive layouts for different screen sizes

## 🔧 Development

### Code Style
- Follows Dart/Flutter best practices
- Uses BLoC pattern for state management
- Implements Clean Architecture principles
- Comprehensive error handling and logging

### Testing
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for user flows

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Contact

For questions or support, please open an issue on GitHub.

---

**Built with ❤️ using Flutter**
