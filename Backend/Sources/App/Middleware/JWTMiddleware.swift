import Vapor
import JWT

struct JWTMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "Missing authorization token")
        }
        
        let payload = try request.jwt.verify(token, as: UserPayload.self)
        request.auth.login(payload)
        
        return try await next.respond(to: request)
    }
}
