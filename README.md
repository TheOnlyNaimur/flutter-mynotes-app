# MyNotes 📝

A beautifully designed, cross-platform notes app built with **Flutter** and powered by **Firebase**. Create, manage, share, and search your notes — all synced in real time to the cloud.

---

## 📥 Download

**[⬇️ Download MyNotes v1.0.1 (Android APK)](https://github.com/TheOnlyNaimur/flutter-mynotes-app/releases/download/v1.0.1/MyNotes.apk)**

> Requires Android 5.0 (Lollipop) or higher. Enable "Install from unknown sources" in your device settings before installing.

All releases: [github.com/TheOnlyNaimur/flutter-mynotes-app/releases](https://github.com/TheOnlyNaimur/flutter-mynotes-app/releases)

---

## ✨ Features

- **📋 Create & Edit Notes** — Add a title and body to every note. Notes are auto-saved as you type.
- **🗑️ Delete Notes** — Remove notes you no longer need with a single tap.
- **🔍 Search Notes** — Instantly filter your notes by title or content using the built-in search.
- **📤 Share Notes** — Share any note via the native Android share sheet (WhatsApp, email, and more).
- **☁️ Real-Time Cloud Sync** — All notes are stored in Cloud Firestore and sync instantly across sessions.
- **🔐 Authentication** — Secure sign-up and login with email and password via Firebase Auth.
- **✉️ Email Verification** — New accounts must verify their email before accessing notes.
- **🌙 Dark / Light Theme** — The app automatically follows your device's system theme.

---

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| [Flutter](https://flutter.dev) | Cross-platform UI framework |
| [Firebase Auth](https://firebase.google.com/products/auth) | User authentication |
| [Cloud Firestore](https://firebase.google.com/products/firestore) | Real-time cloud database |
| [Firebase Analytics](https://firebase.google.com/products/analytics) | Usage analytics |
| [share_plus](https://pub.dev/packages/share_plus) | Native share functionality |

---

## 🚀 Getting Started (for developers)

Follow these steps to run the project locally.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.10.8 or higher)
- A [Firebase project](https://console.firebase.google.com/) with **Authentication** and **Cloud Firestore** enabled
- Android Studio or VS Code with the Flutter plugin

### 1. Clone the repository

```bash
git clone https://github.com/TheOnlyNaimur/flutter-mynotes-app.git
cd flutter-mynotes-app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

This project uses Firebase. You need to connect it to your own Firebase project:

1. Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2. Add an **Android** app (use package name `com.example.mynotes` or update it to your own).
3. Download `google-services.json` and place it in the `android/app/` directory.
4. Run the FlutterFire CLI to generate `lib/firebase_options.dart`:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 4. Enable Firebase Services

In the Firebase Console, enable the following:

- **Authentication** → Sign-in method → **Email/Password**
- **Cloud Firestore** → Create a database (start in test mode or configure rules)

### 5. Run the app

```bash
flutter run
```

---

## 📁 Project Structure

```
lib/
├── constants/
│   └── routes.dart          # Named route constants
├── models/
│   └── cloud_note.dart      # CloudNote data model
├── services/
│   └── cloud_storage_service.dart  # Firestore CRUD operations
├── view/
│   ├── login_view.dart          # Login screen
│   ├── register_view.dart       # Registration screen
│   ├── verify_email.dart        # Email verification screen
│   ├── notes_view.dart          # Main notes list screen
│   └── create_update_note_view.dart  # Create/edit note screen
└── main.dart                # App entry point & theme setup
```

---

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m 'Add your feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a Pull Request

---

## 📄 License

This project is open source. See the repository for details.

