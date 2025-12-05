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


## 🚀 Quickstart (local)

### **Test du SDK Flutter seul**

Installer les dépendances :

```bash
cd azeoo_flutter_sdk
flutter pub get
```

Lancer le SDK en mode "exemple" (testé avec émulateur Android, voir vidéo) :

```bash
flutter run 
```

---

## 🧪 Test de l'intégration React Native

### **Prérequis**

- Flutter SDK 3.38.3+ : [Installation Flutter](https://flutter.dev/docs/get-started/install)
- Android SDK avec NDK 27.1.12297006
- Node.js 18+ et npm
- JDK 17+
- Gradle 8.13+
- Émulateur Android ou appareil physique

### **Structure du projet**

```
TestAZIOO/
├─ azeoo_flutter_module/    → Module Flutter (compilé en AAR)
├─ azeoo_flutter_sdk/        → SDK Flutter standalone
└─ azeoo_rn_app/             → Application React Native hôte
```

### **Étapes d'installation et test**

#### **1. Configurer Flutter SDK path**

Vérifiez que Flutter est accessible :

```bash
flutter --version
```

Si vous utilisez un chemin personnalisé (comme `C:\Users\modes\Desktop\flutter`) (c'est ce que j'utilise), mettez à jour :

```bash
# Dans azeoo_flutter_module/.android/local.properties
flutter.sdk=C:/Users/modes/Desktop/flutter
```

#### **2. Build du module Flutter en AAR**

```bash
cd azeoo_flutter_module
flutter pub get
flutter build aar --no-tree-shake-icons
```

✅ **Résultat attendu** : Les AARs sont générés dans `build/host/outputs/repo/`
- `flutter_debug-1.0.aar`
- `flutter_release-1.0.aar`
- `flutter_profile-1.0.aar`

#### **3. Installer les dépendances React Native**

```bash
cd ../azeoo_rn_app
npm install
```

#### **4. Build et installation de l'app**

**Option A : Build classique**
```bash
npx react-native run-android
```

**Option B : Clean build (si erreurs)**
```bash
cd android
./gradlew clean
cd ..
npx react-native run-android
```

#### **5. Test de l'application**

Une fois l'app installée :

1. **Onglet Input** : Saisissez un ID utilisateur 
2. **Cliquez sur "Sauvegarder"**
3. **Onglet Profile** : Le profil Flutter s'affiche avec :
   - Photo de profil
   - Nom complet (prénom + nom)
   - Informations (genre, âge, ville)
   - Points, Followers, Workouts
   - Email
   - Badges récents

---

## ⚠️ Problèmes rencontrés et solutions

### **1. Gradle Plugin Incompatibility**

**❌ Erreur** :
```
Project.afterEvaluate(Action) when already evaluated
```

**Cause** : React Native 0.82 nécessite Gradle 8.13+, mais le plugin Flutter ne supporte pas cette version.

**✅ Solution** : Build Flutter en **AAR** (Android Archive) au lieu d'intégration directe.

```bash
cd azeoo_flutter_module
flutter build aar
```

Puis importer l'AAR dans `azeoo_rn_app/android/app/build.gradle` :

```gradle
repositories {
    maven {
        url 'C:/Users/modes/Desktop/TestAZIOO/azeoo_flutter_module/build/host/outputs/repo'
    }
}

dependencies {
    debugImplementation 'com.example.azeoo_flutter_module:flutter_debug:1.0'
    releaseImplementation 'com.example.azeoo_flutter_module:flutter_release:1.0'
}
```

---

### **2. Profile Build Type Incompatibility**

**❌ Erreur** :
```
Profile variant not supported by React Native libraries
```

**Cause** : React Native ne supporte que `debug` et `release`, pas `profile`.

**✅ Solution** : Retirer le buildType `profile` de `android/app/build.gradle`.

---

### **3. ActivityNotFoundException**

**❌ Erreur** :
```
android.content.ActivityNotFoundException: Unable to find explicit activity class
```

**Cause** : `AzeooFlutterActivity` non déclarée dans `AndroidManifest.xml`.

**✅ Solution** : Ajouter dans `android/app/src/main/AndroidManifest.xml` :

```xml
<activity
    android:name=".AzeooFlutterActivity"
    android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
    android:hardwareAccelerated="true"
    android:windowSoftInputMode="adjustResize"
    android:theme="@style/LaunchTheme"
    android:exported="false" />
```

Et créer `android/app/src/main/res/values/styles.xml` :

```xml
<resources>
    <style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
        <item name="android:windowBackground">@android:color/white</item>
    </style>
</resources>
```

---

### **4. UserId toujours à 1 (problème SharedPreferences)**

**❌ Problème** : Le profil affiche toujours l'utilisateur ID 1, même après avoir saisi un autre ID. Normal, pour le premier test, j'ai mis directement l'id pour afficher le résultat

**Cause** : 
- SharedPreferences React Native et Flutter utilisent des namespaces différents
- L'Intent ne passe pas le userId correctement

**✅ Solution** : Créer une `AzeooFlutterActivity` personnalisée qui :

1. **Récupère le userId depuis l'Intent** :

```kotlin
// AzeooFlutterActivity.kt
class AzeooFlutterActivity : FlutterActivity() {
    private var userId: Int = 1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        userId = intent.getIntExtra("userId", 1)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "azeoo/channel")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialUserId" -> result.success(userId)
                    else -> result.notImplemented()
                }
            }
    }
}
```

2. **Lance l'Activity avec le userId** :

```kotlin
// AzeooFlutterModule.kt
@ReactMethod
fun openProfile(userId: Int, promise: Promise?) {
    val intent = Intent(reactContext, AzeooFlutterActivity::class.java)
    intent.putExtra("userId", userId)
    intent.putExtra("cached_engine_id", "azeoo_engine")
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    reactContext.startActivity(intent)
    promise?.resolve(true)
}
```

3. **Flutter lit le userId au démarrage** :

```dart
// azeoo_sdk.dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  return FutureBuilder<int>(
    future: getInitialUserId().then((id) => id ?? initialUserId),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      final effectiveUserId = snapshot.data!;
      // ... utilise effectiveUserId pour la navigation
    }
  );
}
```

---

### **5. Photo de profil et email ne s'affichent pas**

**❌ Problème** : Les champs `profilePicture` et `email` sont vides, points/followers/workouts à 0.

**Cause** : L'endpoint API était incorrect (`/v1/users/me` au lieu de `/v1/users/{id}`). Je savais pas que me représentait l'id

**✅ Solution** : Corriger l'endpoint dans `user_repository.dart` :

```dart
@override
Future<User> refreshUser(int id) async {
  final json = await apiClient.getJson('/v1/users/$id');  // Correct
  final user = User.fromJson(json);
  return user;
}
```

**Avant (incorrect)** :
```dart
final json = await apiClient.getJson('/v1/users/me', headers: {'X-User-Id': '$id'});
```

---

## 🔍 Debug et logs

### **Vérifier les logs Flutter**

```bash
adb logcat | Select-String "flutter|AzeooFlutter|getInitialUserId"
```

### **Nettoyer les logs**

```bash
adb logcat -c
```

### **Vérifier l'AAR généré**

```bash
ls azeoo_flutter_module/build/host/outputs/repo/com/example/azeoo_flutter_module/
```

Vous devriez voir :
```
flutter_debug/1.0/
flutter_release/1.0/
flutter_profile/1.0/
```

### **Clean build Android**

Si vous rencontrez des erreurs de cache :

```bash
cd azeoo_rn_app/android
./gradlew clean
cd ../..
adb uninstall com.azeoo_rn_app
npx react-native run-android
```

---

## 📋 Checklist avant de tester

- [ ] Flutter SDK 3.38.3+ installé
- [ ] Android SDK configuré avec NDK 27.1.12297006
- [ ] Node.js 18+ et npm installés
- [ ] `flutter.sdk` path configuré dans `azeoo_flutter_module/.android/local.properties`
- [ ] AAR Flutter build (`flutter build aar`)
- [ ] Dépendances npm installées (`npm install`)
- [ ] Émulateur Android démarré ou appareil connecté (android)
- [ ] Port Metro 8081 disponible

---

## 🎯 Test réussi

Si tout fonctionne, vous devriez voir :

1. **App React Native** avec 2 onglets (Input / Profile)


---

