# Private Notes Light
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/emircihangir/private_notes_light)

Private Notes Light is a secure, offline-first, and lightweight note-taking application built with Flutter. It prioritizes user privacy by storing all notes locally on your device and encrypting them with a master password.

## Features

*   **Local-First Storage:** All your notes are stored locally on your device using `sqflite`. No cloud, no servers, no tracking.
*   **Strong Encryption:** Notes are encrypted using AES with a key derived from your master password. The master password itself is never stored.
*   **Backup and Restore:** Easily export all your notes and settings into a single JSON file for backup. You can import this file to restore your data on any device.
*   **Privacy-Enhanced UI (iOS):** The app content is automatically blurred when switching apps or when screen recording is active to protect your private information. It also provides a warning when a screenshot is taken.
*   **Clean & Simple UI:** A minimal, distraction-free interface for creating and managing notes.
*   **Theme Customization:** Switch between Light, Dark, and System default themes.
*   **Search:** Quickly find the note you're looking for with the built-in search functionality.

## Security Model

The security of your notes is the top priority. Here’s how it works:

1.  **Sign-Up:** When you set your master password, the app generates a random, strong master encryption key. This master key is then encrypted using a separate key derived from your password and a unique salt (using a PBKDF2-like key stretching process). Only this encrypted master key is stored.
2.  **Login:** When you enter your password, the app re-derives the key and attempts to decrypt the stored master key. If successful, the decrypted master key is held in memory to encrypt/decrypt your notes for the session.
3.  **Data at Rest:** All note content is stored in the local SQLite database in its encrypted form.

**Important:** Because your password is never stored, there is **no password recovery**. If you forget your master password, your notes will be permanently inaccessible.

## Architecture

The project follows a clean, feature-driven architecture inspired by Domain-Driven Design (DDD) principles. Each feature is organized into its own directory with a clear separation of concerns:

*   `application`: Contains services and controllers (business logic).
*   `data`: Implements repositories for data access (e.g., database, shared preferences).
*   `domain`: Defines the core models (entities, DTOs) and repository contracts.
*   `presentation`: Contains the UI widgets and screens.

State management is handled declaratively using **Riverpod**.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   [Flutter SDK](https://flutter.dev/docs/get-started/install)

### Installation

1.  Clone the repository:
    ```sh
    git clone https://github.com/emircihangir/private_notes_light.git
    ```
2.  Navigate to the project directory:
    ```sh
    cd private_notes_light
    ```
3.  Install dependencies:
    ```sh
    flutter pub get
    ```
4.  The project uses `build_runner` for code generation. Run the following command to generate the necessary files:
    ```sh
    dart run build_runner build --delete-conflicting-outputs
    ```
5.  Run the app:
    ```sh
    flutter run