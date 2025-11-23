import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let apiService = APIService.shared
    private let keychainService = KeychainService.shared
    
    func checkAuthentication() {
        if let token = keychainService.getToken() {
            isAuthenticated = true
            Task {
                await fetchProfile()
            }
        }
    }
    
    func signup(email: String, password: String, name: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await apiService.signup(email: email, password: password, name: name)
            keychainService.saveToken(response.token)
            currentUser = response.user
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await apiService.login(email: email, password: password)
            keychainService.saveToken(response.token)
            currentUser = response.user
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func logout() {
        keychainService.deleteToken()
        currentUser = nil
        isAuthenticated = false
    }
    
    func fetchProfile() async {
        do {
            currentUser = try await apiService.getProfile()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
