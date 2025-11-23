import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    var email: String
    var name: String
    var preferences: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email, name, preferences
    }
}

struct SignupRequest: Codable {
    let email: String
    let password: String
    let name: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct AuthResponse: Codable {
    let token: String
    let user: User
}

struct UpdateProfileRequest: Codable {
    let name: String
    let preferences: String?
}

struct ErrorResponse: Codable {
    let error: String
}
