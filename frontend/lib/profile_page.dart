import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'main.dart';

class UserProfilePage extends StatefulWidget {
  final String uid; // 传入用户ID
  const UserProfilePage({super.key, required this.uid});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  String? _avatarUrl;
  String? _username; // 用户名
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // 获取用户名和头像
  }

  // 获取用户信息（用户名 + 头像）
  Future<void> _fetchUserProfile() async {
    final url = Uri.parse("${getApiBaseUrl()}/api/auth/user/${widget.uid}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _avatarUrl = data['avatar'];  // 获取头像
        _username = data['username']; // 获取用户名
      });
    } else {
      debugPrint("Failed to fetch user profile");
    }
  }

  // 选择图片并上传
  Future<void> _pickAndUploadImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes); // 转换为 Base64

    final url = Uri.parse("${getApiBaseUrl()}/api/avatar/upload");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"uid": widget.uid, "avatar": base64Image}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _avatarUrl = base64Image; // 本地更新头像
      });
    } else {
      debugPrint("Failed to upload image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 显示头像
            GestureDetector(
              onTap: _pickAndUploadImage, // 点击上传头像
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _avatarUrl != null
                    ? MemoryImage(base64Decode(_avatarUrl!)) // Base64 转 Image
                    : const AssetImage('assets/default_avatar.jpg') as ImageProvider,
                child: _avatarUrl == null
                    ? const Icon(Icons.camera_alt, size: 30, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // 显示用户名
            Text(
              _username ?? "Loading...",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickAndUploadImage,
              child: const Text("Upload Avatar"),
            ),
          ],
        ),
      ),
    );
  }
}