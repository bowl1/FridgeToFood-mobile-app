import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'recipe_search_page.dart';

class AuthCheckPage extends StatelessWidget {
  const AuthCheckPage({super.key});

  Future<User?> _checkUserStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // 模拟 Firebase 加载
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _checkUserStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), // 加载中
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        } else if (snapshot.data != null) {
          // 已登录，跳转到搜索页面
          return RecipeSearchPage();
        } else {
          // 未登录，跳转到登录页面
          return LoginPage();
        }
      },
    );
  }
}