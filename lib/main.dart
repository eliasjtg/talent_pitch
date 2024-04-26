import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talent_pitch/app/routes/router.dart';
import 'package:talent_pitch/app/theme.dart';

void main() {
  runApp(
    /// For widgets to be able to read providers, we need to wrap the entire
    /// application in a "ProviderScope" widget.
    /// This is where the state of our providers will be stored.
    const ProviderScope(
      child: App(),
    ),
  );
}

/// Main App widget
class App extends StatelessWidget {
  const App({super.key});

  /// This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Talent Pitch',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: lightTheme(context),
      routerConfig: router,
    );
  }
}
