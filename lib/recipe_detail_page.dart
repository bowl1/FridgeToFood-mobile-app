import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class RecipeDetailPage extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  RecipeDetailPageState createState() => RecipeDetailPageState();
}

class RecipeDetailPageState extends State<RecipeDetailPage> {
  bool isFavorite = false; // 记录是否收藏
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 收藏菜谱到 MongoDB
  void _toggleFavorite() async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint("User not logged in.");
      return;
    }

    final token = await user.getIdToken(); // 获取 Firebase 认证 Token
    final url = Uri.parse('${getApiBaseUrl()}/api/favorites');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',  // ✅ 确保 Token 发送
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "id": widget.recipe["id"],
        "name": widget.recipe["name"],
        "image": widget.recipe["image"],
        "tags": widget.recipe["tags"],
        "ingredients": widget.recipe["ingredients"],
        "steps": widget.recipe["steps"],
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        isFavorite = !isFavorite; // 切换收藏状态
      });
      debugPrint("Recipe added to favorites.");
    } else {
      debugPrint("Failed to add favorite: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = widget.recipe['ingredients'] as List<dynamic>? ?? [];
    final steps = widget.recipe['steps'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe['name'] ?? 'Recipe Details'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            color: isFavorite ? Colors.red : null,
            onPressed: _toggleFavorite,  // ✅ 点击按钮收藏
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            widget.recipe['image'] != null
                ? Image.network(
              widget.recipe['image'],
              height: 200,
              fit: BoxFit.cover,
            )
                : const Icon(Icons.fastfood, size: 200),
            const SizedBox(height: 16.0),
            Text(
              "Ingredients:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...ingredients.map((ingredient) => Text("- ${ingredient['name']}")),
            const SizedBox(height: 16.0),
            Text(
              "Steps:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...steps.map((step) => Text("- $step")),
          ],
        ),
      ),
    );
  }
}