import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'recipe_search_page.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final logger = Logger();
  bool _isLogin = true;

  Future<void> _register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(_usernameController.text.trim());
        await user.reload();
      }

      String? token = await user?.getIdToken();
      if (token == null) {
        _showMessage("Token 获取失败");
        return;
      }

      bool isStored = await _saveUserToMongoDB(token);
      if (isStored) {
        _showMessage("Register successful!");
        if (mounted) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => RecipeSearchPage()));
        }
      } else {
        _showMessage("注册成功，但存储到 MongoDB 失败");
      }
    } catch (e) {
      _showMessage("Register failed: $e");
    }
  }

  Future<bool> _saveUserToMongoDB(String? token) async {
    if (token == null) return false;

    final url = Uri.parse("${getApiBaseUrl()}/api/auth/register");
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": _emailController.text.trim(),
        "username": _usernameController.text.trim(),
      }),
    );

    return response.statusCode == 201;
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String? token = await userCredential.user?.getIdToken();
      await _saveToken(token);
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => RecipeSearchPage()));
      }
    } catch (e) {
      logger.e("Login failed: $e");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 5)),
    );
  }

  Future<void> _saveToken(String? token) async {
    if (token == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? "Login" : "Register")), // **标题根据模式变化**
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_isLogin) // **仅注册时显示用户名输入框**
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _isLogin ? _login : _register,
              child: Text(_isLogin ? "Login" : "Register"),
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin; // **切换模式**
                });
              },
              child: Text(_isLogin
                  ? "Don't have an account? Register"
                  : "Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}