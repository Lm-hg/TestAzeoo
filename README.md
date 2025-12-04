<<<<<<< HEAD
# TestAzeoo
=======
# Azeoo Flutter SDK — Version Humanisée

Ce dépôt propose un **SDK Flutter prêt à l’emploi**, pensé pour être utilisé dans plusieurs environnements :

* une application **React Native** (via Flutter Add-to-App),
* une application **Android native**,
* une application **iOS native**.

L’idée est simple : offrir un bloc Flutter autonome que l’hôte peut afficher tel quel, sans se soucier de la logique interne.


##  Objectif du SDK

Le SDK a un but précis : afficher un **profil utilisateur** — prénom, nom, avatar — en s’appuyant sur :

* une API REST sécurisée,
* une gestion propre du chargement, des erreurs et du rafraîchissement,
* un cache minimal pour améliorer la réactivité,
* une interface publique simple et stable :

```dart
AzeooSDK.userProfileApp(initialUserId: 1)
```

Ce point d’entrée renvoie un widget complet, prêt à être inséré dans n’importe quelle app hôte.


## 🧱 Organisation du projet

Le projet est structuré en modules clairs et faciles à maintenir :

```
lib/
 ├─ core/          → ApiClient, cache, exceptions
 ├─ domain/        → modèles métiers (User), repositories
 ├─ presentation/  → pages, widgets, providers Riverpod
 ├─ navigation/    → configuration go_router
 └─ sdk/           → API publique du SDK (AzeooSDK)
```

Cette séparation facilite l’intégration, le test et l’évolution du SDK.


##  Choix techniques (et pourquoi)

### **State management : Riverpod**

* Simple à tester
* Facile à override depuis l’hôte (React Native, natif)
* Parfait pour un SDK modulaire qui peut vivre dans des environnements variés

### **Navigation : go_router**

* Déclaratif
* Compatible deep-links
* Idéal pour composer des écrans exposés à un hôte externe

### **API : ApiClient centralisé**

* Gestion centralisée des headers
* Traitement d’erreurs unifié
* Injection propre via Riverpod

### **Cache : SharedPreferences (fallback en mémoire)**

* Suffisant pour garder le dernier profil consulté
* Simple à nettoyer et à diagnostiquer

### **Pas de Flutter “built-in” pour la logique**

* Aucun `setState` ou `Navigator`
* Toute la logique repose sur Riverpod + go_router, comme demandé


##  API & Headers

L’API cible :
`https://api.azeoo.dev`

Le SDK envoie automatiquement :

* `Accept-Language: fr-FR`
* `Authorization: Bearer <token>`
* `X-User-Id: <id>`

Conforme au `curl` fourni :

```bash
curl --location 'https://api.azeoo.dev/v1/users/me' \
  --header 'Accept-Language: fr-FR' \
  --header 'X-User-Id: 1' \
  --header 'Authorization: Bearer api_...'
```


## 🪄 Comment l’hôte utilise le SDK ?

Le cœur de l’intégration tient en une ligne :

```dart
AzeooSDK.userProfileApp(initialUserId: 1)
```

Si l’hôte souhaite fournir sa propre configuration (token, baseUrl, langue…), il peut override le provider :

```dart
ProviderScope(
  overrides: [
    sdkConfigProvider.overrideWithValue(
      SdkConfig(
        baseUrl: 'https://staging.my-api.dev',
        token: 'api_xxx',
      ),
    ),
  ],
  child: AzeooSDK.userProfileApp(initialUserId: 1),
);
```

C’est l’un des avantages de Riverpod : l’hôte garde le contrôle.


##  Fonctionnement de l’écran Profil

* **Chargement** → un loader s’affiche tant que les données arrivent
* **Cache** → si un profil existe déjà, il s’affiche immédiatement
* **Rafraîchissement** → pull-to-refresh pour recharger l'utilisateur
* **Erreurs** → affichées clairement (message simple), sans casser le cache


##  Fichiers essentiels

* `core/api_client.dart` → gestion HTTP + headers
* `core/cache.dart` → cache minimal
* `domain/models/user.dart` → modèle User
* `domain/repositories/user_repository.dart` → cache + API + refresh
* `presentation/providers.dart` → providers Riverpod clés
* `presentation/pages/profile_page.dart` → UI du profil
* `sdk/azeoo_sdk.dart` → point d’entrée public du SDK


## Quickstart (local)

Installer les dépendances :

```bash
flutter pub get
```

Lancer le SDK en mode “exemple” je l'ai testé avec mon émulateur android( voir vidéeo) :

```bash
flutter run 
```

>>>>>>> 09c401c (mise en place du sdk flutter)
