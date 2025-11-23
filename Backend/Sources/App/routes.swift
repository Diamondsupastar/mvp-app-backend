import Vapor
import JWT

func routes(_ app: Application) throws {
    // Configure JWT
    app.jwt.signers.use(.hs256(key: "secret-key-change-in-production"))
    
    // Health check
    app.get("health") { req in
        return ["status": "ok"]
    }
    
    // Register controllers
    try app.register(collection: UserController())
}
