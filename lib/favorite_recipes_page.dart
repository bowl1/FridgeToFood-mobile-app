import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'recipe_detail_page.dart';
import 'main.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  FavoritePageState createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {
  List<dynamic> _favorites = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  // 获取当前用户的收藏
  Future<void> _fetchFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return; // 确保用户已登录

    final token = await user.getIdToken(); // 获取 Firebase 认证 Token
    final url = Uri.parse('${getApiBaseUrl()}/api/favorites');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', //  添加 Token 确保后端知道是谁
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _favorites = json.decode(response.body);
      });
    } else {
      debugPrint("Failed to load favorites");
    }
  }

  // 删除收藏的菜谱
  void _removeFavorite(String recipeId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final token = await user.getIdToken();
    final url = Uri.parse('${getApiBaseUrl()}/api/favorites/$recipeId');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _favorites.removeWhere((recipe) => recipe["id"] == recipeId);
      });
    } else {
      debugPrint("Failed to remove favorite");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Recipes")),
      body: _favorites.isEmpty
          ? const Center(child: Text("No favorite recipes yet."))
          : ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final recipe = _favorites[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: recipe['image'] != null
                  ? Image.network(recipe['image'], width: 80, height: 80, fit: BoxFit.cover)
                  : const Icon(Icons.fastfood, size: 80),
              title: Text(recipe['name'] ?? "No Name"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeFavorite(recipe["id"]),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}