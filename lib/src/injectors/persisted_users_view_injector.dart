import 'package:bus2/core/core.dart';
import 'package:bus2/src/repositories/repositories.dart';
import 'package:bus2/src/view_models/view_models.dart';

class PersistedUsersViewInjector extends DependencyInjector {
  @override
  void dependencies() {
    put<UserRemoteRepository>(UserRemoteRepository(local: find()));

    lazyPut<PersistedUsersViewModel>(
      () => PersistedUsersViewModel(
        repository: find(),
        local: find(),
        navigator: find(),
      ),
    );
  }
}
