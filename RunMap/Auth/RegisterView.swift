//
//  RegisterView.swift
//  RunMap
//
//  Created by Aisha on 18.02.25.
//

import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showPassword = false
    @State private var isRegistered = false
    @State private var isLoading = false
    var onRegisterSuccess: () -> Void
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 200)

            Text("Create Your Account")
                .font(.largeTitle)
                .bold()
                .padding(.bottom)

            VStack {
                TextField("e-mail", text: $email)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                HStack {
                    if showPassword {
                        TextField("password", text: $password)
                            .autocapitalization(.none)
                    } else {
                        SecureField("password", text: $password)
                    }
                    
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

                Button(action: {
                    Task {
                        do {
                            try await AuthService.shared.register(email: email, password: password)
                            isRegistered = true
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
                }) {
                    Text("Register")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .font(.footnote)
                }
                
                Button("Already have an account? Login") {
                    onRegisterSuccess()
                }
                .padding(.top, 16)
                .foregroundColor(.blue)
                
            }
            .padding()
        }
    }

    func registerUser() {
        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address."
            return
        }

        isLoading = true
        
        Task {
            do {
                try await AuthService.shared.register(email: email, password: password)
                print("Registration successful")
                isRegistered = true
                isLoading = false
                onRegisterSuccess()
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
 
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

//#Preview {
//    RegisterView()
//}
