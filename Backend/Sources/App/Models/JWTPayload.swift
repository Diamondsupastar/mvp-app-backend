import JWT
import Vapor

// UserPayload conforms to both JWTPayload and Authenticatable
struct UserPayload: JWTPayload, Authenticatable {
    var userId: UUID
    var exp: ExpirationClaim
    
    func verify(using signer: JWTSigner) throws {
        try exp.verifyNotExpired()
    }
}
