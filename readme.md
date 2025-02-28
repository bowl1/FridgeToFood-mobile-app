# FridgeToFood Backend

This is the backend service for the **FridgeToFood** mobile app, which helps users generate recipes based on the ingredients available in their refrigerator.

##  Features
- User authentication 
- Favorite recipes stored in MongoDB
- Recipe and category data provided by Low Carb Recipes API
- API endpoints for mobile app integration

##  Tech Stack
- **Backend Framework**: Node.js with Express
- **Database**: MongoDB 
- **Authentication**: Firebase
- **External API**: Low Carb Recipes API (for recipes and categories)

##  Setup & Installation

### 1. Install dependencies:
```
 npm install
```

### 2. Run the server:
```
 mongosh
 node index.js
```
The backend will run on `http://localhost:5001/` by default.

## API Endpoints

###  User Authentication
| Method | Endpoint          | Description |
|--------|------------------|-------------|
| POST   | `/api/auth/register` | Register a new user |
| POST   | `/api/auth/login`    | Authenticate user & return token |

### Favorite Recipes
| Method | Endpoint                | Description |
|--------|------------------------|-------------|
| GET    | `/api/favorites`       | Get user's favorite recipes |
| POST   | `/api/favorites/add`   | Add a recipe to favorites |
| DELETE | `/api/favorites/:id`  | Remove a recipe from favorites |

###  Recipe Data (Provided by Low Carb Recipes API)
| Method | Endpoint                | Description |
|--------|------------------------|-------------|
| GET    | `/api/recipes`         | Fetch recipes from Low Carb Recipes API |
| GET    | `/api/categories`      | Fetch recipe categories |
