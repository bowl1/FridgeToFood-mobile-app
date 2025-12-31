const express = require("express");
const { connectDB } = require("../db"); // 连接数据库
const router = express.Router();

/** 
 *  上传用户头像 (Base64)
 *  前端需要传递: { uid: "用户ID", avatar: "Base64字符串" }
 */
router.post("/upload", async (req, res) => {
  try {
    const db = await connectDB();
    const usersCollection = db.collection("users");

    const { uid, avatar } = req.body;
    if (!uid || !avatar) {
      return res.status(400).json({ message: "Missing parameters" });
    }

    // 更新或插入头像数据
    await usersCollection.updateOne(
      { uid },
      { $set: { avatar } },
      { upsert: true }
    );

    res.status(200).json({ message: "Avatar uploaded successfully" });
  } catch (error) {
    console.error("Failed to upload avatar:", error);
    res.status(500).json({ message: "Failed to upload avatar" });
  }
});

/** 
 *  获取用户头像 
 *  请求: GET /api/avatar/:uid
 *  返回: { avatar: "Base64字符串" }
 */
router.get("/:uid", async (req, res) => {
  try {
    const db = await connectDB();
    const usersCollection = db.collection("users");

    const { uid } = req.params;
    const user = await usersCollection.findOne({ uid });

    if (!user || !user.avatar) {
      return res.status(404).json({ message: "Avatar not found" });
    }

    res.json({ avatar: user.avatar });
  } catch (error) {
    console.error("Failed to fetch avatar:", error);
    res.status(500).json({ message: "Failed to fetch avatar" });
  }
});

module.exports = router;