import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'recipe_detail_page.dart';
import 'filter_page.dart';
import 'profile_page.dart';
import 'favorite_recipes_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

// RapidAPI 密钥在构建时通过 --dart-define=RAPIDAPI_KEY=xxx 传入，避免硬编码
const String rapidApiKey = String.fromEnvironment('RAPIDAPI_KEY');
const String rapidApiHost = 'low-carb-recipes.p.rapidapi.com';

class RecipeSearchPage extends StatefulWidget {
  const RecipeSearchPage({super.key});
  @override
  RecipeSearchPageState createState() => RecipeSearchPageState();
}

class RecipeSearchPageState extends State<RecipeSearchPage> {
  final TextEditingController _keywordController = TextEditingController();
  String _message = "Enter the food in your fridge.";
  String? _selectedTag;  // 当前选中的筛选条件
  List<dynamic> _allRecipes = [];  // 存储所有获取到的菜谱
  List<dynamic> _recipes = [];  // 存储当前筛选后的菜谱
  User? _currentUser;

  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser; // 获取当前用户
  }

  // 登出方法
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginPage())
      );
    }
  }

  // 查找菜谱的功能
  void _findRecipes() async {
    final keyword = _keywordController.text.trim();

    if (keyword.isEmpty) {
      setState(() {
        _message = "Please enter an ingredient.";
      });
      return;
    }

    // 构建tags字符串
    String tagQuery = _selectedTag != null && _selectedTag!.isNotEmpty
        ? '&tags=${_selectedTag!}'
        : '';

    if (rapidApiKey.isEmpty) {
      setState(() {
        _message = "Missing RapidAPI key. Please set RAPIDAPI_KEY via --dart-define.";
      });
      return;
    }

    // API 请求 URL
    String urlString = 'https://low-carb-recipes.p.rapidapi.com/search?includeIngredients=$keyword$tagQuery';

    final url = Uri.parse(urlString);
    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': rapidApiKey,
        'X-RapidAPI-Host': rapidApiHost,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is List) {
        setState(() {
          _allRecipes = data;  // **存储所有获取的菜谱**
          _applyFilter();  // **应用筛选**
        });
      } else {
        setState(() {
          _message = "Unexpected data format for recipes.";
        });
      }
    } else {
      setState(() {
        _message = "Failed to fetch recipes.";
      });
    }
  }

  void _applyFilter() {
    setState(() {
      if (_selectedTag == null || _selectedTag!.isEmpty || _selectedTag == "Reset") {
        _recipes = _allRecipes; // 没有筛选条件，显示所有数据
      } else {
        _recipes = _allRecipes.where((recipe) {
          return recipe['tags'] != null && (recipe['tags'] as List).contains(_selectedTag);
        }).toList();
      }

      _message = _recipes.isEmpty ? "No matching recipes found." : "Found ${_recipes.length} recipes.";
    });
  }

  // 打开筛选页面并返回选中的筛选标签
  void _navigateToFilterPage() async {
    final selectedTag = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FilterPage(selectedTag: _selectedTag)),
    );

    if (selectedTag != null) {
      setState(() {
        _selectedTag = selectedTag;
        _applyFilter();  // **只筛选，不重新请求 API**
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fridge to Table'),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: _logout),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _navigateToFilterPage,  // 点击筛选按钮
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _keywordController,
              decoration: const InputDecoration(
                labelText: 'Enter food in your fridge',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _findRecipes, // 点击按钮后调用查找菜谱的功能
              child: const Text('Find Recipes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16.0),
            Text(_message, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16.0),
            _recipes.isEmpty
                ? const Text('No recipes found.')
                : Expanded(
              child: ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  final recipe = _recipes[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4.0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      leading: CachedNetworkImage(
                        imageUrl: recipe['thumbnail'] ?? recipe['image'], // 优先加载小图
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const CircularProgressIndicator(), // 加载中的占位符
                        errorWidget: (context, url, error) => const Icon(Icons.error), // 失败时的替代图标
                      ),
                      title: Text(recipe['name'] ?? 'No Name'),
                      onTap: () {
                        // 点击菜谱名称，进入详情页面
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailPage(recipe: recipe),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),  // ⭐ 收藏按钮
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),  // 👤 我的信息
            label: 'My Profile',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritePage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserProfilePage(uid: _currentUser!.uid)),
            );
          }else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please log in first!")),
            );
          }
        },
      ),
    );

  }
}
