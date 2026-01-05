import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:consult/providers/bottom_nav_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BottomNavProvider', () {
    test('loads last selected tab index from SharedPreferences', () async {
      // Arrange: Pretend we previously saved tab index = 2
      SharedPreferences.setMockInitialValues({'last_tab': 2});

      // Act
      final provider = BottomNavProvider();

      // Wait a tick for the async _loadIndex() in constructor to complete
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      // Assert
      expect(provider.isLoading, isFalse);
      expect(provider.currentIndex, 2);
    });
  });
}
