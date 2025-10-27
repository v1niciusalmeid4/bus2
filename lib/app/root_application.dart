import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:bus2/app/app.dart';
import 'package:bus2/core/core.dart';
import 'package:bus2/instance/instance.dart';

class RootApplication extends StatefulWidget {
  const RootApplication({super.key});

  @override
  State<RootApplication> createState() => _RootApplicationState();
}

class _RootApplicationState extends State<RootApplication>
    with WidgetsBindingObserver {
  late bool isInitialized;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    isInitialized = false;

    ContainerInjector().put<NavigatorService>(NavigatorServiceImpl());

    InstanceInjector().dependencies();

    for (var element in screens) {
      element.injector?.dependencies();
    }

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationMaterialApp(
      title: 'Way Data',
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          titleTextStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      screens: screens,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
