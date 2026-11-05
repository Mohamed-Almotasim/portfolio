import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/features/app_simulator/demo_app_registry.dart';
import 'package:portfolio/features/app_simulator/demo_count.dart';

void main() {
  test('liveDemoCount matches the registry', () {
    expect(
      liveDemoCount,
      DemoAppRegistry.demos.length + DemoAppRegistry.animations.length,
    );
  });
}
