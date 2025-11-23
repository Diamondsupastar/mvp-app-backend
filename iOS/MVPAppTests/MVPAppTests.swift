import XCTest
@testable import MVPApp

final class MVPAppTests: XCTestCase {
    
    func testUserModelDecoding() throws {
        let json = """
        {
            "id": "123e4567-e89b-12d3-a456-426614174000",
            "email": "test@example.com",
            "name": "Test User",
            "preferences": "Dark mode"
        }
        """.data(using: .utf8)!
        
        let user = try JSONDecoder().decode(User.self, from: json)
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.name, "Test User")
        XCTAssertEqual(user.preferences, "Dark mode")
    }
    
    func testSignupRequestEncoding() throws {
        let request = SignupRequest(email: "test@example.com", password: "password123", name: "Test User")
        let data = try JSONEncoder().encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        XCTAssertEqual(json?["email"] as? String, "test@example.com")
        XCTAssertEqual(json?["password"] as? String, "password123")
        XCTAssertEqual(json?["name"] as? String, "Test User")
    }
    
    func testLoginRequestEncoding() throws {
        let request = LoginRequest(email: "test@example.com", password: "password123")
        let data = try JSONEncoder().encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        XCTAssertEqual(json?["email"] as? String, "test@example.com")
        XCTAssertEqual(json?["password"] as? String, "password123")
    }
    
    func testKeychainService() {
        let keychain = KeychainService.shared
        let testToken = "test-jwt-token-12345"
        
        keychain.saveToken(testToken)
        let retrievedToken = keychain.getToken()
        XCTAssertEqual(retrievedToken, testToken)
        
        keychain.deleteToken()
        let deletedToken = keychain.getToken()
        XCTAssertNil(deletedToken)
    }
    
    func testAuthViewModelInitialState() {
        let viewModel = AuthViewModel()
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNil(viewModel.currentUser)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testProfileViewModelInitialState() {
        let viewModel = ProfileViewModel()
        XCTAssertEqual(viewModel.name, "")
        XCTAssertEqual(viewModel.preferences, "")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
}
