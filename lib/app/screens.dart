import 'package:bus2/core/architecture/screen.dart';

import 'package:bus2/src/injectors/injectors.dart';
import 'package:bus2/src/view_models/view_models.dart';
import 'package:bus2/src/views/views.dart';

final screens = <Screen>[
  Screen(
    name: HomeViewModel.route,
    page: (context) => HomeView(),
    injector: HomeViewInjector(),
  ),
  Screen(
    name: UserDetailsViewModel.route,
    page: (context) => UserDetailsView(),
    injector: UserDetailsViewInjector(),
  ),
  Screen(
    name: PersistedUsersViewModel.route,
    page: (context) => PersistedUsersView(),
    injector: PersistedUsersViewInjector(),
  ),
];
