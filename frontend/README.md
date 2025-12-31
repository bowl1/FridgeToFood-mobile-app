# Fridge to Food
A smart recipe app that helps you create delicious meals based on the ingredients in your fridge.

## Overview
Fridge to Table is a cross-platform mobile application built with Flutter. 
It allows users to search for recipes based on available ingredients, filter results based on dietary preferences, and save favorite recipes. 
Users can also manage their profiles and upload avatars.

## Tech Stack
| Category       | Technology              |
| -------------- | ----------------------- |
| Frontend       | Flutter (Dart)          |
| Backend        | Node.js + Express.js    |
| Database       | MongoDB                 |
| Authentication | Firebase Authentication |

## Features

 - Search recipes based on available ingredients
 - Filter recipes by dietary preferences (e.g., vegetarian, keto, gluten-free)
 - Save and manage favorite recipes
 - User authentication with Firebase
 - Profile management with avatar uploads
 - Cross-platform support (iOS & Android)

## API (Backend)

Auth
- `POST /auth/register` — Register (Firebase token required)
- `POST /auth/login` — Login (Firebase token required)
- `GET /auth/user/:uid` — Get user profile

Favorites (Bearer Firebase ID token)
- `GET /favorites` — List favorites for current user
- `POST /favorites` — Add favorite
- `DELETE /favorites/:id` — Remove favorite

Avatar
- `POST /avatar/upload` — Upload avatar (base64)

## How to run 
- One command (from repo root): `./start.sh <flutter-device-id> [port]`  
  - Example: `./start.sh chrome 5001` (or `macos` / emulator ID). Installs backend deps, starts API, then runs Flutter.
  - Set `USE_AUTH_EMULATOR=1` if you want to use the Firebase Auth emulator; otherwise it hits live Firebase.

## Screenshot 

![flow.gif](images%2Fflow.gif)

### Android
<div style="display: flex; flex-wrap: wrap; gap: 10px;">
  <img src="images/And1.png" alt="Description" width="200">
  <img src="images/And2.png" alt="Description" width="200">
  <img src="images/And3.png" alt="Description" width="200">
  <img src="images/And4.png" alt="Description" width="200">
  <img src="images/And5.png" alt="Description" width="200">
  <img src="images/And6.png" alt="Description" width="200">
  <img src="images/And7.png" alt="Description" width="200">
</div>

### Ios
<div style="display: flex; flex-wrap: wrap; gap: 10px;">
  <img src="images/ios0.png" alt="Description" width="200">
  <img src="images/ios1.png" alt="Description" width="200">
  <img src="images/ios2.png" alt="Description" width="200">
  <img src="images/ios3.png" alt="Description" width="200">
  <img src="images/ios4.png" alt="Description" width="200">
  <img src="images/ios5.png" alt="Description" width="200">
  <img src="images/ios6.png" alt="Description" width="200">
  <img src="images/ios7.png" alt="Description" width="200">
</div>
