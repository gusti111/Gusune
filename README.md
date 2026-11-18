<div align="center">

# GUSTUNE

**A hybrid music-player concept for Flutter.**

A mobile application exploring local music, library management, and connected audio experiences.

</div>

---

## Overview

Gustune is a Flutter-based music-player project. The current source tree establishes an authenticated application shell, bottom-tab navigation, a local Isar data layer, and dependencies for audio playback and media discovery.

The product direction combines a local music library with network-based discovery and playback capabilities. Feature availability should be checked against the current implementation before treating any workflow as release-ready.

## Current foundation

- Flutter application with Material theming and portrait orientation.
- Login gate backed by secure session-token storage.
- Riverpod state management.
- Main navigation for Home, Search, Library, and Profile.
- Isar database initialization and a repository layer for offline tracks and playlists.
- Dependencies for audio playback, background media controls, local media queries, image caching, and network requests.
- Light and dark theme definitions.

## Technology

| Area | Technology |
| --- | --- |
| Application | Flutter / Dart |
| State management | Riverpod |
| Audio | just_audio, audio_service, just_audio_background |
| Local data | Isar |
| Secure storage | flutter_secure_storage |
| Networking | Dio |
| Media discovery | on_audio_query, youtube_explode_dart |
| UI | Material, Google Fonts, SVG, animations |

## Requirements

- Flutter SDK with Dart 3.3 or newer.
- Android Studio / Android SDK or Xcode for the target platform.
- A device or emulator supported by the selected audio and storage plugins.

## Getting started

    git clone https://github.com/gusti111/Gusune.git
    cd Gusune
    flutter pub get

The repository includes generated-code dependencies for Isar and Riverpod. When generated models or providers change, run the relevant build runner command:

    dart run build_runner build --delete-conflicting-outputs

Start the application:

    flutter run

## Architecture

    lib/
    ├── core/
    │   ├── database/       # Isar setup and repositories
    │   ├── services/       # Shared platform services
    │   ├── theme/          # Theme definitions
    │   └── utils/          # Validation and utilities
    └── features/
        ├── auth/           # Authentication screens
        ├── home/           # Home experience
        └── navigation/     # Main tab navigation

Additional feature directories may be introduced as the product develops.

## Development and responsible media use

- Keep authentication tokens in secure storage, not ordinary preferences or source files.
- Validate file existence before attempting to play locally stored tracks.
- Use media sources and downloads only where you have the necessary rights and where the source platform permits the intended use.
- Review platform-specific permissions and background-audio behavior before release.

## Project status

The repository is under active development. Its dependency manifest describes the intended audio and media capabilities, but does not by itself prove every player, streaming, or download flow is complete. Verify each workflow on a physical device before release.

## Author

**Gusty Faqikh** · [GitHub](https://github.com/gusti111)