import JWT
import Vapor

struct UserPayload: JWTPayload {
    var userId: UUID
    var exp: ExpirationClaim
    
    func verify(using signer: JWTSigner) throws {
        try exp.verifyNotExpired()
    }
}
