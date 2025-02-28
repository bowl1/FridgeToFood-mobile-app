// firebaseAdmin.js
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// 定义并导出 verifyToken 函数
const verifyToken = async (token) => {
  try {
    const decodedUser = await admin.auth().verifyIdToken(token);
    return decodedUser;
  } catch (error) {
    console.error("Token verification failed:", error);
    return null;  // 返回 null 以便后续处理
  }
};

module.exports = { verifyToken };  // 导出 verifyToken 函数