import 'package:flutter/material.dart';

import 'package:bus2/core/core.dart';

class ApplicationMaterialApp extends StatefulWidget {
  final String title;
  final List<Screen> screens;
  final Locale locale;
  final Iterable<Locale> supportedLocales;
  final ThemeData theme;
  final ThemeData darkTheme;

  final Iterable<LocalizationsDelegate> localizationsDelegates;
  final bool debugShowCheckedModeBanner;
  final ThemeMode? themeMode;
  final Route<dynamic>? Function(RouteSettings?)? onGenerateRoute;

  const ApplicationMaterialApp({
    required this.title,
    required this.screens,
    required this.locale,
    required this.supportedLocales,
    required this.theme,
    required this.darkTheme,
    required this.localizationsDelegates,
    this.debugShowCheckedModeBanner = false,
    this.themeMode,
    this.onGenerateRoute,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ApplicationMaterialAppState createState() => _ApplicationMaterialAppState();
}

class _ApplicationMaterialAppState extends State<ApplicationMaterialApp> {
  Map<String, Screen> get screensMap =>
      widget.screens.asMap().map((key, value) => MapEntry(value.name, value));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigatorService.key,
      title: widget.title,
      locale: widget.locale,
      initialRoute: '/home',
      supportedLocales: widget.supportedLocales,
      darkTheme: widget.darkTheme,
      theme: widget.theme,
      themeMode: widget.themeMode ?? ThemeMode.system,
      localizationsDelegates: widget.localizationsDelegates,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      onGenerateRoute: onGenerateRoute,
      onUnknownRoute: (settings) {
        return null;
      },
    );
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final screen = screensMap[settings.name];

    if (screen == null) {
      return null;
    }

    return MaterialPageRoute(builder: (context) => screen.page(context));
  }
}
