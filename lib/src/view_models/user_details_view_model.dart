import 'package:flutter/material.dart';

import 'package:bus2/core/core.dart';
import 'package:bus2/src/models/user_model.dart';
import 'package:bus2/src/repositories/repositories.dart';

class UserDetailsViewModel extends ChangeNotifier {
  static const String route = '/user_details';

  final UserRemoteRepository repository;
  final UserLocalRepository local;
  final NavigatorService navigator;

  UserDetailsViewModel({
    required this.repository,
    required this.local,
    required this.navigator,
  });

  late UserModel user;

  bool isPersisted = false;

  Future<void> onInit() async {
    user = navigator.getArguments() as UserModel;

    isPersisted = await local.userExistsByUuid(user.login.uuid);

    notifyListeners();
  }

  Future<void> onRemovePersistedUser() async {
    await local.removeUser(user.login.uuid);
    isPersisted = false;
    notifyListeners();
  }

  Future<void> onPersistUser() async {
    await local.saveUser(user);
    isPersisted = true;
    notifyListeners();
  }
}
