# 📝 BlogHub

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Dart-blue?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Backend-FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white" />
  <img src="https://img.shields.io/badge/Database-MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white" />
  <img src="https://img.shields.io/badge/Language-Python-3776AB?style=for-the-badge&logo=python&logoColor=white" />
</p>

<p align="center">
  <b>A full-stack blog platform with a Flutter mobile app, Python FastAPI backend, and MySQL database.</b>
</p>

---

## 🚀 Tech Stack

| Layer | Technology |
|---|---|
| 📱 Mobile App | Flutter (Dart) |
| ⚙️ Backend | Python FastAPI |
| 🗄️ Database | MySQL |
| 🔐 Auth | JWT Token |
| 📦 State Management | Provider |
| 🌐 HTTP Client | Dio |

---

## 📂 Project Structure

```
blog_hub/
├── lib/
│   ├── core/
│   │   ├── network/          # API client, config, headers
│   │   └── utils/            # Enums, helpers, preference keys
│   ├── features/
│   │   ├── auth/             # Login & Register
│   │   │   ├── controller/
│   │   │   ├── service/
│   │   │   └── view/
│   │   ├── splash/           # Splash screen
│   │   ├── dashboard/
│   │   │   ├── admin dashboard/   # Admin user management
│   │   │   └── user dashboard/    # User posts dashboard
│   │   ├── global feed/      # All posts feed
│   │   ├── profile/          # User profile
│   │   ├── add_edit_post/    # Create & edit posts
│   │   └── components/       # Shared UI components
│   └── main.dart
├── android/
├── ios/
├── assets/
│   └── image/
└── pubspec.yaml
```

---

## 🔌 Backend API

| Detail | Value |
|---|---|
| Framework | Python FastAPI |
| Base URL | `http://192.168.1.164:8000` |
| Swagger Docs | [http://192.168.1.164:8000/docs#](http://192.168.1.164:8000/docs#) |
| Auth | JWT Bearer Token |

### API Endpoints

| Method | Endpoint | Description | Access |
|---|---|---|---|
| `POST` | `/auth/register` | Register new user | Public |
| `POST` | `/auth/login` | Login & get JWT token | Public |
| `GET` | `/users/` | Get all users | Admin |
| `GET` | `/users/{id}` | Get user by ID | Self / Admin |
| `PUT` | `/users/{id}` | Update user | Admin |
| `DELETE` | `/users/deactivate/{id}` | Deactivate user | Admin |
| `DELETE` | `/users/hard/{id}` | Hard delete user | Admin |
| `GET` | `/posts/` | Get all posts | Authenticated |
| `GET` | `/posts/{id}` | Get post by ID | Authenticated |
| `POST` | `/posts/` | Create new post | Authenticated |
| `PUT` | `/posts/{id}` | Update post | Owner |
| `DELETE` | `/posts/{id}` | Delete post | Owner |

---

## 🗄️ Database

| Detail | Value |
|---|---|
| Database | MySQL |
| ORM | SQLAlchemy (via FastAPI) |

### Tables

**`users`**
```sql
id          INT PRIMARY KEY AUTO_INCREMENT
firstname   VARCHAR
lastname    VARCHAR
email       VARCHAR UNIQUE
password    VARCHAR (hashed)
role        ENUM('user', 'admin')
is_active   BOOLEAN
created_at  DATETIME
updated_at  DATETIME
```

**`posts`**
```sql
id          INT PRIMARY KEY AUTO_INCREMENT
title       VARCHAR
content     TEXT
user_id     INT (FK → users.id)
created_at  DATETIME
updated_at  DATETIME
```

---

## 📱 App Features

### 🔐 Authentication
- User registration with validation
- JWT login with role-based routing
- Splash screen with auto-login detection

### 👤 User Dashboard
- View only own posts
- Post count stats (total, updated, this month)
- Search & filter posts
- Recent posts carousel
- Create new post
- Read & edit own posts with progress bar

### 🌍 Global Feed
- Browse all posts from all users
- Search by title, content, or author
- Read any post (read-only)

### 🛡️ Admin Dashboard
- View, search all users
- Edit user details
- Deactivate / hard delete users
- User stats (total, active, inactive)

### 📄 Post Read Screen
- Full article view with scroll progress bar
- Edit button (own posts only)
- Read time estimation

### 👤 Profile Screen
- View personal info from API
- Role badge (User / Admin)
- Account creation & update dates

### 🗂️ Drawer Navigation
- My Profile
- My Dashboard
- Global Feed
- Admin Dashboard *(admin only)*
- Logout with confirmation dialog

---

## ⚙️ Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio / VS Code
- Python `>=3.10`
- MySQL Server

### Flutter App Setup

```bash
# Clone the repository
git clone https://github.com/deeppatel2610/blog_hub.git

# Navigate to project
cd blog_hub

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Backend Setup

```bash
# Install Python dependencies
pip install fastapi uvicorn sqlalchemy pymysql python-jose passlib

# Start the FastAPI server
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

### Environment Configuration

Update the base URL in `lib/core/network/api_config.dart`:

```dart
class ApiConfig {
  static const String baseUrl = "http://	http://192.168.1.164:8000";
  // ...
}
```

---

## 📦 Flutter Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5+1        # State management
  dio: ^5.9.1              # HTTP client
  shared_preferences: ^2.2.3  # Local storage
  jwt_decode: ^2.0.1       # JWT token decoding
```

---

## 🎨 Design System

| Element | Value |
|---|---|
| Background | `#0D0D0D` |
| Surface | `#141414` / `#1A1A1A` |
| Primary | `#FF6B35` (Orange) |
| Secondary | `#FF9A6C` (Light Orange) |
| Success | `#4CAF50` (Green) |
| Info | `#42A5F5` (Blue) |
| Warning | `#FFB300` (Amber) |
| Error | `#EF5350` (Red) |
| Admin | `#FFB300` (Gold) |

---

## 🔐 Role-Based Access

| Feature | User | Admin |
|---|---|---|
| View own posts | ✅ | ✅ |
| Create post | ✅ | ✅ |
| Edit own post | ✅ | ✅ |
| View global feed | ✅ | ✅ |
| View profile | ✅ | ✅ |
| View all users | ❌ | ✅ |
| Edit any user | ❌ | ✅ |
| Deactivate user | ❌ | ✅ |
| Delete user | ❌ | ✅ |
| Access admin dashboard | ❌ | ✅ |

---

## 📸 App Flow

```
Splash Screen
    │
    ├── Not logged in ──────► Login Screen ──► Register Screen
    │
    ├── role = admin ────────► Admin Dashboard (+ Drawer)
    │
    └── role = user ─────────► User Dashboard (+ Drawer)
                                    │
                                    ├── Read Post ──► Edit Post
                                    ├── Add New Post
                                    ├── Global Feed
                                    └── Profile Screen
```

---

## 👨‍💻 Developers

<table>
  <tr>
    <td align="center">
      <b>Deep Patel</b><br/>
      📱 Flutter App Developer<br/><br/>
      <a href="https://github.com/deeppatel2610">
        <img src="https://img.shields.io/badge/GitHub-deeppatel2610-181717?style=for-the-badge&logo=github" />
      </a><br/>
      <a href="https://github.com/deeppatel2610/blog_hub">
        <img src="https://img.shields.io/badge/Repo-blog__hub-FF6B35?style=for-the-badge&logo=github" />
      </a>
    </td>
    <td align="center">
      <b>Soham Reshamwala</b><br/>
      ⚙️ Python FastAPI Backend Developer<br/><br/>
      <a href="https://github.com/sohamreshamwala0107">
        <img src="https://img.shields.io/badge/GitHub-sohamreshamwala0107-181717?style=for-the-badge&logo=github" />
      </a><br/>
      <a href="https://github.com/sohamreshamwala0107/BlogHub_API">
        <img src="https://img.shields.io/badge/Repo-BlogHub__API-009688?style=for-the-badge&logo=github" />
      </a>
    </td>
  </tr>
</table>

---

## 🔗 Related Repositories

| Repository | Description | Link |
|---|---|---|
| 📱 Flutter App | Mobile frontend built with Dart & Flutter | [blog_hub](https://github.com/deeppatel2610/blog_hub) |
| ⚙️ FastAPI Backend | RESTful API backend built with Python FastAPI | [BlogHub_API](https://github.com/sohamreshamwala0107/BlogHub_API) |

---

## 📄 License

This project is for educational purposes.

---

<p align="center">Made with ❤️ by <a href="https://github.com/deeppatel2610">Deep Patel</a> & <a href="https://github.com/sohamreshamwala0107">Soham Reshamwala</a></p>
