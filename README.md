# ACLC Online Quiz Application

A comprehensive Flutter mobile application designed for ACLC students to take online quizzes and track their academic progress.

## 📱 Features

### ✅ Implemented
- **Onboarding Flow**: Welcome slides with app introduction
- **Authentication**: Login screen with form validation
- **Dashboard**: Home tab with quick stats and recent activity
- **Course Management**: Browse and view detailed course information
- **Quiz System**: Browse available quizzes with detailed views
- **Results Tracking**: Performance analytics and quiz results
- **User Profile**: Profile management with settings and edit functionality
- **Notifications**: Notification system for important updates
- **Settings**: Settings screen placeholder for future enhancements
- **Edit Profile**: Profile editing placeholder for future enhancements

### 🚧 In Development
- Registration screen
- Quiz taking interface
- Enhanced settings functionality
- Enhanced profile editing
- Backend integration
- State management implementation

## 🏗️ Architecture

### Folder Structure
The project follows a feature-based folder structure for better organization:

```
lib/
├── models/          # Data models (User, Course, Quiz, etc.)
├── screens/         # UI screens organized by feature
│   ├── auth/        # Authentication screens
│   ├── home/        # Main navigation and dashboard
│   ├── courses/     # Course-related screens
│   ├── quizzes/     # Quiz-related screens
│   ├── results/     # Results and analytics
│   ├── profile/     # Profile management
│   ├── settings/    # Settings screens
│   └── notifications/ # Notification screens
├── utils/           # Utilities and constants
└── widgets/         # Reusable UI components
```

## 🎨 Design System

### Color Scheme
- **Primary**: #1565C0 (University Blue)
- **Secondary**: #0D47A1 (Dark Blue)
- **Accent**: #42A5F5 (Light Blue)
- **Success**: #43A047 (Green)
- **Error**: #E53935 (Red)

### UI/UX Features
- Material Design 3 theming
- Consistent university branding
- Responsive design
- Custom reusable widgets
- Intuitive navigation flow

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd online_quiz
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Development Setup

1. **Check Flutter installation**
   ```bash
   flutter doctor
   ```

2. **Run tests**
   ```bash
   flutter test
   ```

3. **Build for production**
   ```bash
   # Android
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   ```

## 📱 Navigation Flow

```
Onboarding Screen → Login Screen → Main Screen (Bottom Navigation)
                                        ├── Home Tab
                                        ├── Courses Tab → Course Details
                                        ├── Quiz Tab → Quiz Details → Quiz Results
                                        ├── Results Tab
                                        └── Profile Tab → Settings/Edit Profile
```

## 🔧 Technical Stack

- **Framework**: Flutter
- **Language**: Dart
- **UI**: Material Design 3
- **Navigation**: Named routes
- **Data**: Mock data (development phase)

## 📋 Current Status

The application is currently in the **UI/UX development phase** with:
- ✅ Complete UI implementation for all major screens
- ✅ Navigation flow between screens
- ✅ Mock data integration
- ✅ Responsive design implementation
- 🚧 Backend integration (planned)
- 🚧 State management (planned)
- 🚧 Authentication logic (planned)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/feature-name`)
3. Commit your changes (`git commit -m 'Add feature'`)
4. Push to the branch (`git push origin feature/feature-name`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions, please contact the development team or create an issue in the repository.

---

**Note**: This application currently uses mock data for demonstration purposes. All screens and functionality are implemented for UI/UX testing and will be connected to a backend service in future iterations.
