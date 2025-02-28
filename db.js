const { MongoClient } = require('mongodb');

const uri = process.env.MONGODB_URI || "mongodb://localhost:27017/recipes"; 

let client;

async function connectDB() {
  try {
    if (!client) {
      client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });
      await client.connect();
      console.log('Successfully connected to MongoDB.');
    }
    return client.db(); // 返回数据库实例
  } catch (err) {
    console.error(' MongoDB connection error:', err);
    throw err;
  }
}

module.exports = { connectDB };