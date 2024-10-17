import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                LogoView()
                
                LoginFormView(username: $viewModel.username, password: $viewModel.password)
                
                LoginButtonView(action: attemptLogin)
            }
            .padding()
        }
        .alert("Erreur de connexion", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Veuillez vérifier vos identifiants et réessayer.")
        }
    }
    
    private func attemptLogin() {
        if viewModel.isValidCredentials() {
            isLoggedIn = true
        } else {
            viewModel.showAlert = true
        }
    }
}

struct LogoView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "lock.shield")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("Bienvenue")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
    }
}

struct LoginFormView: View {
    @Binding var username: String
    @Binding var password: String
    
    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(placeholder: "Nom d'utilisateur", text: $username, systemImage: "person")
            CustomTextField(placeholder: "Mot de passe", text: $password, systemImage: "lock", isSecure: true)
        }
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let systemImage: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.gray)
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct LoginButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Se connecter")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var showAlert: Bool = false
    
    func isValidCredentials() -> Bool {
        return username == "Root" && password == "root"
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}
