# Flutter code base

My flutter code base

## Technical

- [Dependencies injection](https://pub.dev/packages/injectable)
- [State management Bloc/Cubit](https://pub.dev/packages/flutter_bloc)
- [Flavor development/product](https://medium.com/@animeshjain/build-flavors-in-flutter-android-and-ios-with-different-firebase-projects-per-flavor-27c5c5dac10b)
- [Internationalizing i18n](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

## Architect

## Note 
There are 2 different type of bloc we can use. I want to choose to use the different bloc for different purpose:

- for global bloc: use Bloc
- for local bloc: use Cubit

Why? Because global state change can be from anywhere in the app, any screen, so it makes sense to trigger an event from 1 screen, and state is updated in all related screens in the app.
However, as for local bloc, the event and state are in the same screen, so it really doesn’t matter if the trigger is an event or a function call. Therefore, to simplify the code, I think cubit is better choice.


##terminal
- flutter build android flavor dev -t lib/main_dev.dart
- flutter gen-l10n
- flutter packages pub run build_runner build
