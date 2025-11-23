import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showProfile = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if let user = authViewModel.currentUser {
                    VStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                        
                        Text("Hello, \(user.name)!")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(user.email)
                            .foregroundColor(.secondary)
                        
                        if let preferences = user.preferences, !preferences.isEmpty {
                            Text("Preferences: \(preferences)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)
                        }
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            showProfile = true
                        }) {
                            Label("Edit Profile", systemImage: "person.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            authViewModel.logout()
                        }) {
                            Label("Sign Out", systemImage: "arrow.right.square")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showProfile) {
                if let user = authViewModel.currentUser {
                    ProfileView(user: user)
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
