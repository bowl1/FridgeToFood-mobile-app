import 'dart:io'; // 用于检测平台
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_check_page.dart'; // 确保你的登录逻辑
import 'firebase_options.dart';

// ✅ 动态获取 API 地址
String getApiBaseUrl() {
  if (Platform.isIOS) {
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