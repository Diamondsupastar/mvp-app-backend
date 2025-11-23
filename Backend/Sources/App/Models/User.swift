import Vapor
import Fluent

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    @Field(key: "name")
    var name: String
    
    @OptionalField(key: "preferences")
    var preferences: String?
    
    init() {}
    
    init(id: UUID? = nil, email: String, passwordHash: String, name: String, preferences: String? = nil) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
        self.name = name
        self.preferences = preferences
    }
}

// DTOs
struct SignupRequest: Content {
    let email: String
    let password: String
    let name: String
}

struct LoginRequest: Content {
    let email: String
    let password: String
}

struct AuthResponse: Content {
    let token: String
    let user: UserResponse
}

struct UserResponse: Content {
    let id: UUID
    let email: String
    let name: String
    let preferences: String?
    
    init(from user: User) throws {
        self.id = try user.requireID()
        self.email = user.email
        self.name = user.name
        self.preferences = user.preferences
    }
}

struct UpdateProfileRequest: Content {
    let name: String
    let preferences: String?
}

struct ErrorResponse: Content {
    let error: String
}
