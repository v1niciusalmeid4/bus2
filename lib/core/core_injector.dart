import 'package:bus2/core/core.dart';

class CoreInjector extends DependencyInjector {
  final List<DependencyInjector> injectors = [
    ArchitectureInjector(),
  ];

  // For test pourposes
  void inject(DependencyInjector injector) {
    injector.dependencies();
  }

  @override
  void dependencies() {
    for (final injector in injectors) {
      inject(injector);
    }
  }
}
