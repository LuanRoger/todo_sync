import 'package:fire_auth_server_client/app/app.dart';
import 'package:fire_auth_server_client/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebase();

  runApp(const ProviderScope(child: App()));
}

Future<void> _initializeFirebase() => Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
