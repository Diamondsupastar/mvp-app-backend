import Vapor
import Fluent
import JWT

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("api", "users")
        
        users.post("signup", use: signup)
        users.post("login", use: login)
        
        let protected = users.grouped(JWTMiddleware())
        protected.get("profile", use: getProfile)
        protected.put("profile", use: updateProfile)
    }
    
    func signup(req: Request) async throws -> AuthResponse {
        let signupRequest = try req.content.decode(SignupRequest.self)
        
        // Check if user exists
        if let _ = try await User.query(on: req.db)
            .filter(\.$email == signupRequest.email)
            .first() {
            throw Abort(.badRequest, reason: "Email already registered")
        }
        
        // Hash password
        let passwordHash = try Bcrypt.hash(signupRequest.password)
        
        // Create user
        let user = User(
            email: signupRequest.email,
            passwordHash: passwordHash,
            name: signupRequest.name
        )
        
        try await user.save(on: req.db)
        
        // Generate token
        let token = try generateToken(for: user, req: req)
        let userResponse = try UserResponse(from: user)
        
        return AuthResponse(token: token, user: userResponse)
    }
    
    func login(req: Request) async throws -> AuthResponse {
        let loginRequest = try req.content.decode(LoginRequest.self)
        
        // Find user
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == loginRequest.email)
            .first() else {
            throw Abort(.unauthorized, reason: "Invalid email or password")
        }
        
        // Verify password
        guard try Bcrypt.verify(loginRequest.password, created: user.passwordHash) else {
            throw Abort(.unauthorized, reason: "Invalid email or password")
        }
        
        // Generate token
        let token = try generateToken(for: user, req: req)
        let userResponse = try UserResponse(from: user)
        
        return AuthResponse(token: token, user: userResponse)
    }
    
    func getProfile(req: Request) async throws -> UserResponse {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.userId, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        return try UserResponse(from: user)
    }
    
    func updateProfile(req: Request) async throws -> UserResponse {
        let payload = try req.auth.require(UserPayload.self)
        let updateRequest = try req.content.decode(UpdateProfileRequest.self)
        
        guard let user = try await User.find(payload.userId, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        user.name = updateRequest.name
        user.preferences = updateRequest.preferences
        
        try await user.save(on: req.db)
        
        return try UserResponse(from: user)
    }
    
    private func generateToken(for user: User, req: Request) throws -> String {
        let payload = UserPayload(
            userId: try user.requireID(),
            exp: .init(value: Date().addingTimeInterval(86400 * 30)) // 30 days
        )
        return try req.jwt.sign(payload)
    }
}
