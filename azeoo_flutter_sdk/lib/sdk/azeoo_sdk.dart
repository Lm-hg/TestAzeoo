import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/profile_page.dart';
import '../presentation/providers.dart';
import '../core/native_channel.dart';

/// Entrée principale du SDK.
/// 
/// Cette méthode retourne un widget Flutter autonome, déjà enveloppé
/// dans un ProviderScope. Il peut donc être utilisé directement dans
/// une app React Native, Android ou iOS.
/// 
/// Le paramètre [initialUserId] sert d’identifiant utilisateur par défaut.
/// Le paramètre [overrides] permet de remplacer des providers (pratique pour
/// les tests ou des intégrations avancées).
class AzeooSDK {
  static Widget userProfileApp({
    required int initialUserId,
    List<Override>? overrides,
  }) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: AzeooSdkWidget(initialUserId: initialUserId),
    );
  }
}

/// Widget racine du SDK.
/// 
/// Ce widget gère :
/// - la navigation (GoRouter)
/// - l’affichage des deux onglets
/// - la communication native (React Native, Android, iOS)
/// - le changement d’onglet via Riverpod (pas de setState)
class AzeooSdkWidget extends ConsumerWidget {
  final int initialUserId;

  const AzeooSdkWidget({
    super.key,
    required this.initialUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Onglet actuellement sélectionné (géré par Riverpod)
    final selectedIdx = ref.watch(selectedTabProvider);

    // Configuration du router principal de l’application SDK.
    final router = GoRouter(
      initialLocation: '/profile/$initialUserId',
      routes: [
        GoRoute(
          path: '/profile/:userId',
          builder: (_, state) {
            final userIdString = state.pathParameters['userId'] ?? '';
            final userId = int.tryParse(userIdString) ?? initialUserId;

            return ProfilePage(userId: userId);
          },
        ),
        GoRoute(
          path: '/other',
          builder: (_, __) => const Scaffold(
            body: Center(child: Text('Onglet 2 — paramètres')),
          ),
        ),
      ],
    );

    // Initialisation du canal natif uniquement une fois.
    final isChannelInitialized = ref.watch(nativeChannelInitializedProvider);

    if (!isChannelInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setupNativeChannel(ref, router);
        ref.read(nativeChannelInitializedProvider.notifier).state = true;
      });
    }

    return MaterialApp.router(
      title: 'Azeoo SDK',
      routerConfig: router,
      theme: ThemeData(primarySwatch: Colors.blue),
      builder: (context, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIdx,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Autre',
              ),
            ],
            onTap: (index) {
              // Mise à jour de l’onglet via Riverpod
              ref.read(selectedTabProvider.notifier).state = index;

              if (index == 0) {
                // Onglet Profil : navigue vers l’utilisateur courant
                router.go('/profile/$initialUserId');
              } else {
                // Onglet Autre
                router.go('/other');
              }
            },
          ),

          // Petit bonus debug activé uniquement en mode debug
          floatingActionButton: kDebugMode
              ? FloatingActionButton(
                  tooltip: 'Debug: simuler un setUserId natif',
                  child: const Icon(Icons.bug_report),
                  onPressed: () async {
                    try {
                      // Force un refresh utilisateur pour les tests
                      await ref.read(userRepositoryProvider).refreshUser(initialUserId);

                      // Force Riverpod à recharger l'utilisateur
                      ref.refresh(userProvider(initialUserId));

                      // Revient sur la page profil
                      router.go('/profile/$initialUserId');
                    } catch (_) {
                      // Éviter tout crash en debug
                    }
                  },
                )
              : null,
        );
      },
    );
  }
}
