const express = require("express");
const { connectDB } = require("../db");
const { verifyToken } = require("../firebaseAdmin"); // 确保使用 Firebase 认证
const router = express.Router();

// 添加收藏
router.post("/", async (req, res) => {
  try {
    const token = req.headers.authorization?.split("Bearer ")[1];
    if (!token) return res.status(401).json({ message: "未提供 Token" });

    const decodedUser = await verifyToken(token);
    if (!decodedUser) return res.status(403).json({ message: "无效 Token" });

    const db = await connectDB();
    const collection = db.collection("favorites");
    const favorite = { ...req.body, uid: decodedUser.uid }; // **添加 uid**

    // 避免重复收藏
    const existingRecipe = await collection.findOne({ uid: decodedUser.uid, id: favorite.id });
    if (existingRecipe) {
      return res.status(400).json({ message: "Recipe already in favorites" });
    }

    await collection.insertOne(favorite);
    res.status(201).json({ message: "Recipe added to favorites" });
  } catch (error) {
    console.error("Failed to add favorite:", error);
    res.status(500).json({ message: "Failed to add favorite" });
  }
});

// 获取用户的收藏列表
router.get("/", async (req, res) => {
  try {
    const token = req.headers.authorization?.split("Bearer ")[1];
    if (!token) return res.status(401).json({ message: "未提供 Token" });

    const decodedUser = await verifyToken(token);
    if (!decodedUser) return res.status(403).json({ message: "无效 Token" });

    const db = await connectDB();
    const collection = db.collection("favorites");
    const favorites = await collection.find({ uid: decodedUser.uid }).toArray(); // **仅返回当前用户的收藏**
    
    res.json(favorites);
  } catch (error) {
    console.error("Failed to fetch favorites:", error);
    res.status(500).json({ message: "Failed to fetch favorites" });
  }
});

// 删除收藏
router.delete("/:id", async (req, res) => {
  try {
    const token = req.headers.authorization?.split("Bearer ")[1];
    if (!token) return res.status(401).json({ message: "未提供 Token" });

    const decodedUser = await verifyToken(token);
    if (!decodedUser) return res.status(403).json({ message: "无效 Token" });

    const db = await connectDB();
    const collection = db.collection("favorites");

    const { id } = req.params;
    await collection.deleteOne({ uid: decodedUser.uid, id });

    res.json({ message: "Recipe removed from favorites" });
  } catch (error) {
    console.error("Failed to remove favorite:", error);
    res.status(500).json({ message: "Failed to remove favorite" });
  }
});

module.exports = router;