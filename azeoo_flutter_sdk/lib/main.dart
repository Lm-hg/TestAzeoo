import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sdk/azeoo_sdk.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SDK Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AzeooSDK.userProfileApp(initialUserId: 1),
    );
  }
}
