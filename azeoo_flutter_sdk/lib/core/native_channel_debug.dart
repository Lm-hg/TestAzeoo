import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/providers.dart';

/// Helper to simulate a native setUserId call from Flutter tests or debug UI.
Future<void> simulateNativeSetUserId(WidgetRef ref, GoRouter router, int id) async {
  if (id <= 0) return;
  await ref.read(userRepositoryProvider).refreshUser(id);
  final _ = ref.refresh(userProvider(id));
  router.go('/profile/$id');
}
