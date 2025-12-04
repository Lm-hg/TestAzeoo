import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_client.dart';
import '../core/cache.dart';
import '../domain/repositories/user_repository.dart';

/// Configuration du SDK.
/// 
/// Ce modèle regroupe :
/// - l’URL de base de l’API,
/// - le token d’accès (fourni par l’hôte),
/// - la langue souhaitée pour les requêtes.
///
/// Le but est de permettre à l’application hôte (React Native, Android, iOS…)
/// de surcharger ces valeurs si nécessaire.
class SdkConfig {
  final String baseUrl;
  final String token;
  final String language;

  const SdkConfig({
    required this.baseUrl,
    required this.token,
    this.language = 'fr-FR',
  });
}

/// Fournit la configuration du SDK.
/// 
/// Par défaut, on expose une configuration “raisonnable”, mais une application
/// intégratrice peut override ce provider au moment où elle instancie le SDK.
/// C’est ce qui rend ton SDK flexible et réutilisable dans plusieurs environnements.
final sdkConfigProvider = Provider<SdkConfig>((ref) {
  return const SdkConfig(
    baseUrl: 'https://api.azeoo.dev',
    token:
        'api_474758da8532e795f63bc4e5e6beca7298379993f65bb861f2e8e13c352cc4dcebcc3b10961a5c369edb05fbc0b0053cf63df1c53d9ddd7e4e5d680beb514d20',
    language: 'fr-FR',
  );
});

/// Client HTTP du SDK.
/// 
/// Il reçoit la configuration (URL, langue, token) et prépare les headers
/// nécessaires à toutes les requêtes vers l’API de Azeoo.
final apiClientProvider = Provider<ApiClient>((ref) {
  final cfg = ref.read(sdkConfigProvider);

  return ApiClient(
    baseUrl: cfg.baseUrl,
    defaultHeaders: {
      'Accept-Language': cfg.language,
      'Authorization': 'Bearer ${cfg.token}',
    },
  );
});

/// Cache simple utilisé dans le SDK.
/// 
/// Pour l’instant minimaliste, mais facile à remplacer par quelque chose
/// de plus avancé si le SDK devait évoluer (Hive, SharedPrefs, sqlite…).
final cacheProvider = Provider<SimpleCache>((ref) {
  return SimpleCache();
});

/// Repository utilisateur.
/// 
/// C’est le cœur de la logique métier :
/// - il va chercher les données auprès de l’API,
/// - il utilise le cache si possible,
/// - il unifie la manière dont on accède à un utilisateur.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    ref.read(apiClientProvider),
    ref.read(cacheProvider),
  );
});

/// Provider Riverpod responsable de charger un utilisateur donné.
/// 
/// `.family` permet de demander, par exemple :
///   ref.watch(userProvider(3))
/// 
/// `.autoDispose` garantit que si la vue disparaît, Riverpod libère
/// automatiquement les ressources (bon pour un SDK qu’on peut monter/démonter).
final userProvider = FutureProvider.family.autoDispose((ref, int userId) async {
  final repo = ref.read(userRepositoryProvider);
  return repo.getUser(userId);
});

/// Onglet sélectionné dans la bottom tabbar.
/// 
/// Géré via Riverpod pour éviter setState() dans un SDK.
final selectedTabProvider = StateProvider<int>((ref) => 0);

/// Indique si le canal natif (communication avec RN/Android/iOS)
/// a déjà été initialisé.
/// 
/// Cela évite plusieurs appels d’initialisation.
final nativeChannelInitializedProvider = StateProvider<bool>((ref) => false);
