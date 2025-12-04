import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/providers.dart';

const MethodChannel _azeooChannel = MethodChannel('azeoo/channel');

/// Configure le handler MethodChannel pour recevoir des commandes natives.
/// Expose la méthode `setUserId` qui force le refresh et navigue vers le profil.
void setupNativeChannel(WidgetRef ref, GoRouter router) {
  _azeooChannel.setMethodCallHandler((call) async {
    try {
      if (call.method == 'setUserId') {
        final arg = call.arguments;
        final id = (arg is int) ? arg : int.tryParse(arg?.toString() ?? '') ?? 0;
        if (id <= 0) return null;

        // Rafraîchir les données et forcer la mise à jour du provider
        await ref.read(userRepositoryProvider).refreshUser(id);
        final _ = ref.refresh(userProvider(id));
        // Naviguer vers la route profil
        router.go('/profile/$id');
      } else if (call.method == 'refresh') {
        // Optionnel : rafraîchir l'onglet courant
        // Implémentation future
      }
    } catch (e) {
      // Ne pas faire échouer le channel : log si besoin
    }
    return null;
  });
}
