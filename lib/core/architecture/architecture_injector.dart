import 'package:bus2/core/core.dart';

class ArchitectureInjector extends DependencyInjector {
  @override
  void dependencies() {
    put<NavigatorService>(NavigatorServiceImpl());
  }
}
