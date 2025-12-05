Instructions d'intégration (Android)

1) Copier les fichiers Kotlin
- Copier `native_patches/AzeooFlutterModule.kt` et `native_patches/AzeooPackage.kt` dans `android/app/src/main/kotlin/<votre_package>/` (remplacez le package en tête si nécessaire).

2) Ajouter le package React Native
- Dans `MainApplication.kt`, ajoutez `AzeooPackage()` à la liste des packages retournés (ou enregistrez via PackageList si vous utilisez la configuration par défaut).

3) Créer et mettre en cache le FlutterEngine
- Dans `android/app/src/main/kotlin/<votre_package>/MainApplication.kt` dans `onCreate()` ajoutez :

```kotlin
val flutterEngine = FlutterEngine(this)
GeneratedPluginRegistrant.registerWith(flutterEngine)
flutterEngine.dartExecutor.executeDartEntrypoint(
    DartExecutor.DartEntrypoint.createDefault()
)
FlutterEngineCache.getInstance().put("azeoo_engine", flutterEngine)
```

4) Inclure le module Flutter (si vous avez créé `azeoo_flutter_module`)
- Dans `android/settings.gradle` (projet RN host) :

```gradle
setBinding(new Binding([gradle: this]))
apply from: "../azeoo_flutter_module/.android/include_flutter.groovy"
```

- Ajustez le chemin relatif si le module est situé ailleurs.

5) Lancer et tester
- Build et run depuis la racine du projet RN host :

```powershell
npx react-native run-android
```

- Dans l'app, onglet 1 entrez `1` ou `3`, appuyez sur Sauvegarder. L'onglet 2 doit tenter d'appeler le module natif; si le module natif est installé il ouvrira l'écran Flutter.

Remarques
- Assurez-vous que la clé d'engin cache est exactement `"azeoo_engine"`.
- Si vous utilisez des plugins Flutter, assurez-vous que `GeneratedPluginRegistrant.registerWith(flutterEngine)` ou l'équivalent moderne est appelé.
