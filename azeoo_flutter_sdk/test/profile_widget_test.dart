import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// no sdk import needed for this unit test
import 'package:azeoo_flutter_sdk/domain/models/user.dart';
import 'package:azeoo_flutter_sdk/domain/repositories/user_repository.dart';
import 'package:azeoo_flutter_sdk/presentation/providers.dart';
import 'package:azeoo_flutter_sdk/presentation/pages/profile_page.dart';

class FakeUserRepository implements UserRepository {
  final User user;
  FakeUserRepository(this.user);

  @override
  Future<User> getUser(int id) async => user;

  @override
  Future<User> refreshUser(int id) async => user;
}

void main() {
  testWidgets('ProfilePage displays user full name', (WidgetTester tester) async {
    final user = User(id: 1, firstName: 'Jean', lastName: 'Dupont');

    // Create a fake userProvider that always returns our user for any id
    final fakeUserProvider = AutoDisposeFutureProvider.family<User, int>((ref, id) async => user);

    // Pump just the ProfilePage inside a MaterialApp to provide Overlay/Navigator
    await tester.pumpWidget(
      ProviderScope(
        overrides: [userProvider.overrideWithProvider(fakeUserProvider)],
        child: const MaterialApp(
          home: ProfilePage(userId: 1),
        ),
      ),
    );

    // Allow async providers to resolve
    await tester.pumpAndSettle();

    expect(find.text('Jean Dupont'), findsOneWidget);
  });
 
}
