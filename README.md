# Fridge to Food
Cross-platform recipe app that helps you turn fridge ingredients into meals.

## Overview
- Search recipes by ingredients and refine with dietary tags (vegetarian, keto, gluten-free, etc.).
- Browse recipe details with images, ingredients, and steps; view thumbnails with cached loading.
- Save/unsave favorites backed by MongoDB and tied to Firebase-authenticated users.
- Sign up/login via Firebase Auth; token forwarding to backend for protected endpoints.
- Manage profile with avatar upload (base64 to backend) and display name.
- Cross-platform Flutter UI (mobile/web/desktop) with bottom navigation to favorites and profile.

## Tech Stack
- Flutter (Dart) UI, cached network images, navigation (bottom bar), form inputs
- Firebase Authentication for sign-up/login/token; Firebase Admin on backend for token verify
- Node.js + Express API with CORS/body-parser; MongoDB persistence for favorites and avatars
- RapidAPI Low Carb Recipes as the external recipe data source
- Shell tooling: `start.sh` to orchestrate backend then frontend

## Project Structure
- `frontend/` Flutter app (auth flow, recipe search/detail, filter page, favorites, profile, assets/screenshots)
- `backend/` Express API (`routes/auth`, `routes/favorites`, `routes/avatar`, `db.js`, `firebaseAdmin.js`)
- `start.sh` one-command launcher (installs deps if missing, starts backend, then runs Flutter)

## Screenshots

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
