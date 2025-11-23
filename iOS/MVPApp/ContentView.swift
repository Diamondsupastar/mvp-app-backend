import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                HomeView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            authViewModel.checkAuthentication()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
