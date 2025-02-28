const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
require("dotenv").config();

const { connectDB } = require("./db");
const favoriteRoutes = require("./routes/favorites");
const authRoutes = require("./routes/auth"); 
const avatarRoutes = require("./routes/avatar"); 


const app = express();

// Middleware
app.use(cors());
// **增加请求体大小限制**
app.use(bodyParser.json({ limit: "50mb" })); // 允许最大 50MB
app.use(bodyParser.urlencoded({ limit: "50mb", extended: true }));

// Root route
app.get("/", (req, res) => {
  res.send("Welcome to the Recipe API with MongoDB and Firebase Auth!");
});

// 启动服务器的函数
async function startServer() {
  try {
    console.log("Connecting to MongoDB...");
    await connectDB(); // 先连接数据库
    console.log("MongoDB connected successfully.");

    // 绑定 API 路由
    app.use("/api/auth", authRoutes); 
    app.use("/api/favorites", favoriteRoutes); 
    app.use("/api/avatar", avatarRoutes); 

    // 监听端口
    const PORT = process.env.PORT || 5001;
    app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
  } catch (error) {
    console.error(" Failed to connect to MongoDB:", error);
    process.exit(1); // 连接失败时退出进程
  }
}

// 启动服务器
startServer();