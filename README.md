# Talent pitch

## Dependencies:

- **flutter_lints**: Contains a set of recommended lints to encourage good coding practices.
- **json_serializable** and **freezed**: Automatically generate code for converting to and from JSON by annotating Dart classes with util methods like copyWith.
- **flutter_riverpod**: Reactive caching and data-binding framework and state management.
- **dio** and **dio_cache_interceptor**: Powerful HTTP networking package with cache interceptor.
- **go_router**: Declarative routing package for Flutter that uses the Router API.
- **cached_network_image**: Load and cache network images.
- **better_player**: Advanced video player based on video_player and Chewie. It's solves many typical use cases and it's easy to run.
- **skeletonizer**: Enhance user experience during web or app loading. It involves displaying a simplified, static version of the user interface while the actual content is being fetched.
- **readmore**: Expanding and collapsing text.
- **collection**: Contains utility functions and classes in the style of `dart:collection` to make working with collections easier.
- **flutter_secure_storage**: Provides API to store data in secure storage. Keychain is used in iOS, KeyStore based solution is used in Android. Used to store custom playlist.

## Decisions:

- **Riverpod** maintains the state of our application in an orderly, efficient and, above all, declarative manner.
- **Dio** with cache to fast requests and return previous cached requests.
- **Better player** to improve video reproduction and user experience, allowing precache incoming videos.
- **Flutter secure storage** to store custom playlist in JSON format.

**Aditional**: Uses `dart format` to keep recommended code format in the app.

A design similar to that of the Talent Pitch productive application was used in terms of the organization of components, simple colors and a minimalist interface.
Regarding optimizations, with Riverpod mostly AutoDisposable states were used, which automatically releases resources when they are no longer being used, the use of Serialization allows better management of the API's responses, transforming, organizing and managing them in a better way. of conversion to and from JSON for better saving in storage and the use of Better player brings with it some improvements to its parent packages, including the preloading of following videos.
The custom playlist uses a state to interact with the connected application with flutter_secure_storage for storage in real time after any changes made.

## Installation:

```bash
# Get dependencies
$ flutter pub get

# Generate translations
$ flutter gen-l10n

# Run code generation to models and states
$ dart run build_runner build
```
