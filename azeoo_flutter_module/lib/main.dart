import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sdk/azeoo_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Le userId sera passé via initialRoute de FlutterActivity
  // On utilise 1 comme valeur par défaut pour les tests standalone
  runApp(const ProviderScope(child: MyApp(initialUserId: 1)));
}

class MyApp extends StatelessWidget {
  final int initialUserId;
  
  const MyApp({super.key, required this.initialUserId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SDK Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AzeooSDK.userProfileApp(initialUserId: initialUserId),
    );
  }
}
