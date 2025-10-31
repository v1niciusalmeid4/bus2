import 'package:flutter/material.dart';

import 'package:bus2/core/core.dart';
import 'package:bus2/src/models/models.dart';
import 'package:bus2/src/repositories/repositories.dart';

class PersistedUsersViewModel extends ChangeNotifier {
  static const String route = '/persisted_users';

  final UserRemoteRepository repository;
  final UserLocalRepository local;
  final NavigatorService navigator;

  PersistedUsersViewModel({
    required this.repository,
    required this.local,
    required this.navigator,
  });

  List<UserModel> _users = [];
  Pageable page = Pageable();

  bool loading = true;
  bool error = false;
  bool reachMax = false;
  String? failureMessage;

  List<UserModel> get users => _users;

  Future<void> onInit() async {
    loading = true;
    notifyListeners();

    final result = await local.findUsers(size: page.size, page: page.page);

    _users = result;
    loading = false;
    reachMax = result.length < page.size;

    notifyListeners();
  }

  Future<void> loadMore() async {
    page.next();

    final result = await local.findUsers(size: page.size, page: page.page);
    _users.addAll(result);
    reachMax = result.length < page.size;

    notifyListeners();
  }

  Future<void> onRemovePersistedUser(String uuid) async {
    await local.removeUser(uuid);
    users.removeWhere((e) => e.login.uuid == uuid);
    notifyListeners();
  }

  Future<void> toUserDetails(final UserModel user) async {
    await navigator.toNamed('/user_details', arguments: user);

    final persisted = await local.userExistsByUuid(user.login.uuid);
    if (persisted) return;

    onRemovePersistedUser(user.login.uuid);
  }
}
