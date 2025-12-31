# 🍽️ Fridge to Food - Ingredient → Recipe Assistant
Flutter app + Node.js API that turns whatever’s in your fridge into cookable recipes, with auth, favorites, and profile management.

## ✨ Features
- Ingredient-first search with dietary filters (vegetarian, keto, gluten-free, etc.).
- Recipe details with images, ingredients, and steps; cached thumbnails for smooth scrolling.
- Favorites backed by MongoDB and tied to Firebase-authenticated users.
- Firebase Auth login/register; tokens forwarded to backend for protected routes.
- Profile center with avatar upload (base64 → backend) and display name.
- Cross-platform Flutter UI (mobile/web/desktop) with bottom navigation to Favorites/Profile.

## ⚙️ Tech Stack
| Category    | Technology |
| ----------- | ---------- |
| Frontend    | Flutter (Dart), cached_network_image |
| Auth        | Firebase Authentication (client) + Firebase Admin (server) |
| Backend     | Node.js, Express.js, CORS/body-parser middleware |
| Database    | MongoDB (favorites, avatars) |
| External API| RapidAPI Low Carb Recipes |
| Tooling     | `start.sh` one-command launcher |

## 🧭 Project Structure
```
.
├── frontend/                    # Flutter app
│   ├── lib/                     # Pages: login, auth check, search, detail, favorites, profile, filters
│   ├── images/                  # Screenshots & GIFs for README
│   └── macos/Podfile            # macOS platform config
├── backend/                     # Express API
│   ├── routes/                  # auth, favorites, avatar
│   ├── db.js                    # Mongo connection
│   └── firebaseAdmin.js         # Firebase Admin setup
├── start.sh                     # One-command launcher (backend + frontend)
└── firebase.json                # Emulator config (auth)
```

## 🏗️ Architecture Overview
- **Frontend (Flutter)**  
  Ingredient search → dietary filter → detail view → favorite toggle (token-auth) → profile with avatar upload.
- **Backend (Express + MongoDB)**  
  Firebase token verification → favorites CRUD → avatar upload/storage → proxy calls to external recipe API.
- **External data**  
  RapidAPI Low Carb Recipes for search results and details.

## 🚀 Screenshots

![flow.gif](frontend/images/flow.gif)

### Android
<div style="display: flex; flex-wrap: wrap; gap: 10px;">
  <img src="frontend/images/And1.png" alt="Description" width="200">
  <img src="frontend/images/And2.png" alt="Description" width="200">
  <img src="frontend/images/And3.png" alt="Description" width="200">
  <img src="frontend/images/And4.png" alt="Description" width="200">
  <img src="frontend/images/And5.png" alt="Description" width="200">
  <img src="frontend/images/And6.png" alt="Description" width="200">
  <img src="frontend/images/And7.png" alt="Description" width="200">
</div>

### iOS
<div style="display: flex; flex-wrap: wrap; gap: 10px;">
  <img src="frontend/images/ios0.png" alt="Description" width="200">
  <img src="frontend/images/ios1.png" alt="Description" width="200">
  <img src="frontend/images/ios2.png" alt="Description" width="200">
  <img src="frontend/images/ios3.png" alt="Description" width="200">
  <img src="frontend/images/ios4.png" alt="Description" width="200">
  <img src="frontend/images/ios5.png" alt="Description" width="200">
  <img src="frontend/images/ios6.png" alt="Description" width="200">
  <img src="frontend/images/ios7.png" alt="Description" width="200">
</div>
