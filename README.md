# RespondeAí - Q&A Platform

A Flutter web application for asking and answering questions, built with Firebase authentication and Firestore database.

## Features

- 🔐 User authentication (login and registration)
- ❓ Ask questions
- 💬 Answer questions from other users
- 📝 View your own questions (answered and unanswered)
- 👤 User profile management
- 🔍 Browse all questions and answers

## Tech Stack

- **Flutter 3.9.2** - UI framework
- **Firebase Auth** - User authentication
- **Cloud Firestore** - Database for questions and users
- **BLoC Pattern** - State management
- **Web Platform** - Responsive web application

## Project Structure

```
lib/
├── bloc/           # Business logic (AuthBloc, QuestionBloc)
├── model/          # Data models (User, Question)
├── provider/       # Firestore data provider
└── view/           # UI screens
    ├── home/       # Presentation/home screen
    ├── profile/    # User profile and authentication
    ├── questions/  # Question views and widgets
    └── shared/     # Shared widgets and components
```

## Getting Started

1. Clone the repository
```bash
git clone https://github.com/malusperancin/responde-ai-flutter.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the application
```bash
flutter run -d chrome
```

## Firebase Collections

- **users** - User profiles (name, email, createdAt)
- **questions** - Questions and answers with timestamps

## State Management

The app uses BLoC pattern with two main blocs:
- **AuthBloc** - Handles authentication states and user session
- **QuestionBloc** - Manages questions loading, creation, and answering
