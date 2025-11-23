import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.dismiss) var dismiss
    
    let user: User
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Information") {
                    TextField("Name", text: $viewModel.name)
                    
                    Text(user.email)
                        .foregroundColor(.secondary)
                }
                
                Section("Preferences") {
                    TextField("Your preferences", text: $viewModel.preferences, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                if let error = viewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                if let success = viewModel.successMessage {
                    Section {
                        Text(success)
                            .foregroundColor(.green)
                            .font(.caption)
                    }
                }
                
                Section {
                    Button(action: {
                        Task {
                            let success = await viewModel.updateProfile()
                            if success {
                                await authViewModel.fetchProfile()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    dismiss()
                                }
                            }
                        }
                    }) {
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            Text("Save Changes")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.blue)
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                viewModel.loadProfile(user: user)
            }
        }
    }
}

#Preview {
    ProfileView(user: User(id: UUID(), email: "test@example.com", name: "Test User", preferences: "Dark mode"))
        .environmentObject(AuthViewModel())
}
