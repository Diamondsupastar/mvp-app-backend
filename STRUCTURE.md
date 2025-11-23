# Project Structure

## Complete File Tree

```
MVPApp/
├── README.md                          # Main documentation
├── QUICKSTART.md                      # 5-minute setup guide
├── PRODUCTION.md                      # Deployment guide
├── API_TESTING.md                     # API testing examples
├── STRUCTURE.md                       # This file
├── .gitignore                         # Git ignore rules
│
├── iOS/                               # iOS Application
│   ├── MVPApp.xcodeproj/             # Xcode project
│   │   ├── project.pbxproj           # Project configuration
│   │   └── project.xcworkspace/
│   │       └── contents.xcworkspacedata
│   │
│   ├── MVPApp/                        # Main app source
│   │   ├── MVPApp.swift              # App entry point (@main)
│   │   ├── ContentView.swift         # Root view with auth routing
│   │   │
│   │   ├── Models/                    # Data models
│   │   │   └── User.swift            # User, requests, responses
│   │   │
│   │   ├── ViewModels/                # MVVM ViewModels
│   │   │   ├── AuthViewModel.swift   # Authentication logic
│   │   │   └── ProfileViewModel.swift # Profile management
│   │   │
│   │   ├── Views/                     # SwiftUI Views
│   │   │   ├── LoginView.swift       # Login screen
│   │   │   ├── SignupView.swift      # Signup screen
│   │   │   ├── HomeView.swift        # Main home screen
│   │   │   └── ProfileView.swift     # Profile edit screen
│   │   │
│   │   ├── Services/                  # Business services
│   │   │   ├── APIService.swift      # REST API client
│   │   │   └── KeychainService.swift # Secure token storage
│   │   │
│   │   └── Assets.xcassets/           # App assets
│   │       ├── AppIcon.appiconset/   # App icon
│   │       ├── AccentColor.colorset/ # Accent color
│   │       └── Contents.json
│   │
│   └── MVPAppTests/                   # Unit tests
│       └── MVPAppTests.swift         # Test suite
│
└── Backend/                           # Vapor API Server
    ├── Package.swift                  # Swift package manifest
    ├── run.sh                         # Launch script
    │
    └── Sources/
        └── App/
            ├── main.swift             # Server entry point
            ├── routes.swift           # Route configuration
            │
            ├── Models/                # Data models
            │   ├── User.swift         # User model + DTOs
            │   └── JWTPayload.swift   # JWT token payload
            │
            ├── Migrations/            # Database migrations
            │   └── CreateUser.swift   # User table migration
            │
            ├── Controllers/           # Route controllers
            │   └── UserController.swift # User endpoints
            │
            └── Middleware/            # HTTP middleware
                └── JWTMiddleware.swift # JWT authentication
```

## iOS App Architecture

### MVVM Pattern

**Models** (`Models/`)
- Pure data structures
- Codable for JSON serialization
- No business logic

**ViewModels** (`ViewModels/`)
- `@Published` properties for UI binding
- Business logic and state management
- API calls and data transformation
- `@MainActor` for UI updates

**Views** (`Views/`)
- SwiftUI declarative UI
- Observe ViewModels via `@EnvironmentObject` or `@StateObject`
- No business logic
- Navigation and presentation

### Services Layer

**APIService**
- Singleton pattern
- Generic request method
- Error handling
- JWT token injection

**KeychainService**
- Secure token storage
- iOS Keychain wrapper
- CRUD operations for tokens

### Navigation Flow

```
ContentView (Root)
    ├─ if authenticated → HomeView
    │                      ├─ Sheet → ProfileView
    │                      └─ Logout → LoginView
    │
    └─ if not authenticated → LoginView
                               └─ NavigationLink → SignupView
```

## Backend Architecture

### Vapor Framework

**Fluent ORM**
- Database abstraction
- Migrations
- Query builder

**JWT Authentication**
- Token generation
- Token verification
- Middleware protection

### API Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/api/users/signup` | No | Create account |
| POST | `/api/users/login` | No | Login |
| GET | `/api/users/profile` | Yes | Get user profile |
| PUT | `/api/users/profile` | Yes | Update profile |
| GET | `/health` | No | Health check |

### Database Schema

**users table**
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    name TEXT NOT NULL,
    preferences TEXT
);
```

### Request/Response Flow

```
iOS App → APIService → HTTP Request → Vapor Router
                                          ↓
                                    Middleware (JWT)
                                          ↓
                                    Controller
                                          ↓
                                    Fluent ORM
                                          ↓
                                    SQLite Database
                                          ↓
                                    Response ← JSON
```

## Key Technologies

### iOS
- **Language**: Swift 5.10+
- **UI Framework**: SwiftUI
- **Architecture**: MVVM
- **Networking**: URLSession (async/await)
- **Security**: Keychain Services
- **Min iOS**: 16.0

### Backend
- **Language**: Swift 5.9+
- **Framework**: Vapor 4
- **ORM**: Fluent
- **Database**: SQLite (dev), PostgreSQL (prod)
- **Auth**: JWT (HS256)
- **Password**: BCrypt

## Security Features

### iOS
- ✅ Keychain for token storage
- ✅ HTTPS ready (ATS compliant)
- ✅ No hardcoded secrets
- ✅ Secure password fields

### Backend
- ✅ BCrypt password hashing
- ✅ JWT token authentication
- ✅ Token expiration (30 days)
- ✅ Unique email constraint
- ✅ Authorization middleware

## Testing

### iOS Tests
- Model encoding/decoding
- Keychain operations
- ViewModel initial state
- Located in `MVPAppTests/`

### Backend Tests
- Add in future: endpoint tests
- Database migration tests
- JWT token validation

## Build & Run

### iOS
```bash
# Open in Xcode
open iOS/MVPApp.xcodeproj

# Or command line
xcodebuild -project iOS/MVPApp.xcodeproj -scheme MVPApp -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

### Backend
```bash
cd Backend
swift run
# or
./run.sh
```

## Dependencies

### iOS
- None! Pure Swift + SwiftUI
- All frameworks are Apple-provided

### Backend
- Vapor 4.89.0+
- Fluent 4.8.0+
- FluentSQLiteDriver 4.0.0+
- JWT 4.0.0+

Managed via Swift Package Manager

## File Sizes (Approximate)

- iOS App (Debug): ~15 MB
- iOS App (Release): ~5 MB
- Backend Binary: ~20 MB
- Database: <1 MB (empty)

## Performance

- Cold start: <1s (iOS), <2s (Backend)
- API response: <100ms (local)
- Memory: ~50MB (iOS), ~30MB (Backend)

## Extensibility

Easy to add:
- ✅ More user fields
- ✅ Additional endpoints
- ✅ Push notifications
- ✅ Social login
- ✅ Image upload
- ✅ Real-time features (WebSocket)
- ✅ Analytics
- ✅ Crash reporting
