const express = require("express");
const { verifyToken } = require("../firebaseAdmin"); // Firebase 认证
const { connectDB } = require("../db");

const router = express.Router();

router.post("/register", async (req, res) => {
  const token = req.headers.authorization?.split("Bearer ")[1]; // 获取 Token
  if (!token) return res.status(401).json({ message: "未提供 Token" });

  try {
    // 验证 Firebase Token，确保是合法用户
    const decodedUser = await verifyToken(token);
    if (!decodedUser) return res.status(403).json({ message: "无效 Token" });

    // 获取数据库
    const db = await connectDB();
    const usersCollection = db.collection("users");

    // 检查用户是否已存在
    const existingUser = await usersCollection.findOne({ uid: decodedUser.uid });
    if (existingUser) {
      return res.status(400).json({ message: "用户已存在" });
    }

    // 存储用户
    const newUser = {
      uid: decodedUser.uid, // Firebase 分配的 UID
      email: decodedUser.email,
      username: req.body.username, // 从前端获取的用户名
      createdAt: new Date(),
    };
    await usersCollection.insertOne(newUser);

    // 返回成功响应
    res.status(201).json({ message: "用户已存入 MongoDB", user: newUser });
  } catch (error) {
    console.error("存储失败:", error);
    res.status(500).json({ message: "存储失败", error: error.message });
  }
});

// 获取用户信息，包括用户名和头像
router.get("/user/:uid", async (req, res) => {
  try {
    const db = await connectDB();
    const usersCollection = db.collection("users");

    const { uid } = req.params;
    const user = await usersCollection.findOne({ uid });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({ username: user.username, avatar: user.avatar });
  } catch (error) {
    console.error("Failed to fetch user profile:", error);
    res.status(500).json({ message: "Failed to fetch user profile" });
  }
});

module.exports = router;