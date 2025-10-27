import 'package:bus2/core/core.dart';

class InstanceInjector extends DependencyInjector {
  @override
  void dependencies() {
    CoreInjector().dependencies();
  }
}
