import 'dart:async';
import 'dart:developer';
import 'package:bus2/core/injection/inj_container.dart';
import 'package:bus2/src/repositories/user_local_repository.dart';
import 'package:flutter/material.dart';

import 'package:bus2/app/app.dart';

Future<void> main() async {
  return runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final datasource = await UserLocalRepository.create();

    ContainerInjector().put<UserLocalRepository>(datasource);

    return runApp(RootApplication());
  }, (error, stackTrace) => log(error.toString(), stackTrace: stackTrace));
}
