import 'package:flutter/material.dart';

import 'package:bus2/core/core.dart';
import 'package:bus2/src/models/models.dart';
import 'package:bus2/src/repositories/repositories.dart';

class HomeViewModel extends ChangeNotifier {
  static const String route = '/home';

  final UserRemoteRepository repository;
  final UserLocalRepository local;
  final NavigatorService navigator;

  HomeViewModel({
    required this.repository,
    required this.local,
    required this.navigator,
  });

  final List<UserModel> _users = [];
  Pageable page = Pageable();

  bool loading = true;
  bool error = false;
  String? failureMessage;

  List<UserModel> get users => _users;

  Future<void> onInit() async {
    loading = true;
    notifyListeners();

    final result = await repository.findUsers(page: page.page, size: page.size);

    result.when(
      success: (s) {
        _users
          ..clear()
          ..addAll(s as List<UserModel>);
        error = false;
        loading = false;
        notifyListeners();
      },
      error: (e) {
        error = true;
        loading = false;
        failureMessage = e;
        notifyListeners();
      },
    );
  }

  Future<void> loadMore() async {
    page.next();

    final result = await repository.findUsers(page: page.page, size: page.size);

    result.when(
      success: (s) {
        _users.addAll(s as List<UserModel>);
        error = false;
        loading = false;
        notifyListeners();
      },
      error: (e) {
        error = true;
        loading = false;
        failureMessage = e;
        notifyListeners();
      },
    );
  }

  Future<void> toPersistedUsers() async {
    navigator.toNamed('/persisted_users');
  }

  void toUserDetails(final UserModel user) {
    navigator.toNamed('/user_details', arguments: user);
  }
}
