# Private Notes Light
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/emircihangir/private_notes_light)

A local-first, end-to-end encrypted notes app for Android and iOS built with Flutter. Every note is encrypted with AES-256 using your master password before being saved to your device. There are no servers, no accounts, and no cloud sync. Everything stays local and entirely under your control.

## Features

- **End-to-end encryption** — Notes are encrypted with AES-256 using a master password-derived key (Argon2id KDF) before being written to disk.
- **Local-only storage** — No servers, no accounts, no internet required.
- **Backup and restore** — Export your encrypted notes to a JSON file and import them on any device. Automatic key rotation is performed when importing a backup encrypted with a different password.
- **Session auto-lock** — The app clears the master key from memory and forces re-authentication when it loses focus.
- **Trash system** — Deleted notes are held in a temporary trash until logout, with undo support.
- **Search** — Filter notes by title instantly.
- **Theme support** — Light, dark, and system theme modes.
- **Change master password** — Re-encrypts the master key with a new password without touching the notes themselves.

## Security Model

- The master password is never stored. Instead, it is used to derive a key via **Argon2id** (16MB memory, 3 iterations, parallelism 4).
- A random 256-bit **master key** is generated at signup and encrypted with the derived key. This encrypted master key is stored in SharedPreferences.
- All notes are encrypted and decrypted in memory using the master key via **AES-256**.
- Note titles are **not encrypted** and are stored in plaintext. A warning is shown to the user.

## Tech Stack

- **Flutter** with Dart
- **Riverpod** for state management
- **SQLite** (via sqflite) for note storage
- **SharedPreferences** for credentials and settings
- **encrypt** package for AES-256
- **cryptography** package for Argon2id key derivation
- **Freezed** for immutable domain models

## Getting Started
```bash
git clone https://github.com/emircihangir/private_notes_light.git
cd private_notes_light
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Testing
```bash
flutter test
```

## License

This project is provided as-is. The developer accepts no responsibility for any loss or inaccessibility of data. Always keep a backup of your notes.