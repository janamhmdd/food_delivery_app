# Twitter Clone Assignment

Flutter Android assignment: a complete Twitter/X-style home feed using the same general feature-first layered structure as `yousseftamer2003/dental_recap`.

## Architecture

`lib/`
- `core/` constants, DI, Firebase, routing, themes, shared widgets
- `features/feed/` data, domain, presentation
- `main.dart` and `twitter_clone_app.dart`

The reference repository uses Flutter + BLoC/GetIt + Firebase packages and separates features into data/domain/presentation layers. This project follows that pattern while keeping the feed self-contained.

## Features

- Twitter-style home feed
- Firestore real-time posts
- Firebase anonymous authentication when Firebase is configured
- Create a post
- Like/unlike
- Repost/unrepost
- Bookmark/unbookmark locally
- Reply count and reply composer
- Pull-to-refresh
- Loading/error/empty states
- Light/dark theme support

## Firebase setup

A real Firebase project cannot be created from someone else's ChatGPT session because it requires access to your Google/Firebase account. The project includes a safe placeholder `firebase_options.dart`.

In Android Studio Terminal:

```bash
dart pub global activate flutterfire_cli
firebase login
flutterfire configure
flutter pub get
flutter run
```

Choose Android and your own Firebase project. Then enable Firestore and Anonymous Authentication in Firebase Console.

## Firestore structure

Collection: `posts/{postId}`

Fields:
- `authorId`: string
- `authorName`: string
- `authorHandle`: string
- `authorAvatarUrl`: string (optional)
- `text`: string
- `createdAt`: Timestamp
- `likes`: number
- `reposts`: number
- `comments`: number

Subcollection: `posts/{postId}/replies/{replyId}`

Fields:
- `authorId`
- `authorName`
- `text`
- `createdAt`

If Firestore is empty, built-in demo tweets are shown so the UI is not blank.

## Open in Android Studio

1. Extract the ZIP.
2. Open the extracted folder in Android Studio.
3. Ensure Flutter and Dart plugins are installed.
4. Run `flutterfire configure`.
5. Run `flutter pub get`.
6. Select an Android emulator/device and run.

Do not submit someone else's Firebase configuration or API credentials.
