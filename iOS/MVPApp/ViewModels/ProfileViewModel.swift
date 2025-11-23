import Foundation
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var preferences: String = ""
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isLoading = false
    
    private let apiService = APIService.shared
    
    func loadProfile(user: User) {
        name = user.name
        preferences = user.preferences ?? ""
    }
    
    func updateProfile() async -> Bool {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        do {
            let updatedUser = try await apiService.updateProfile(name: name, preferences: preferences)
            successMessage = "Profile updated successfully"
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
}
