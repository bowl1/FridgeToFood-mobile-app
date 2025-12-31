import 'dart:io'; // 用于检测平台
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_check_page.dart'; // 确保你的登录逻辑
import 'firebase_options.dart';

const String apiBaseUrlFromEnv = String.fromEnvironment('API_BASE_URL');
const String authEmulatorHost =
    String.fromEnvironment('AUTH_EMULATOR_HOST', defaultValue: '127.0.0.1');
const int authEmulatorPort =
    int.fromEnvironment('AUTH_EMULATOR_PORT', defaultValue: 9099);

// ✅ 动态获取 API 地址
String getApiBaseUrl() {
  if (apiBaseUrlFromEnv.isNotEmpty) {
    return apiBaseUrlFromEnv;
  }

  if (Platform.isIOS || Platform.isMacOS) {
    return "http://localhost:5001";
  } else {
    return "http://10.0.2.2:5001";
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase initialize successfully！");
    debugPrint("API base URL: ${getApiBaseUrl()}");

    // Optional: point Firebase Auth to local emulator if provided
    if (authEmulatorHost.isNotEmpty) {
      await FirebaseAuth.instance.useAuthEmulator(
        authEmulatorHost,
        authEmulatorPort,
      );
      debugPrint("Firebase Auth emulator enabled at $authEmulatorHost:$authEmulatorPort");
    } else {
      debugPrint("Firebase Auth emulator not configured; using live Firebase.");
    }
  } catch (e) {
    debugPrint("Firebase initialize fail: $e");
  }

  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fridge to Table',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      home: const AuthCheckPage(), // 检查用户是否已登录
    );
  }
}
