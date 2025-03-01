//
//  LoginView.swift
//  RunMap
//
//  Created by Aisha on 13.02.25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showPassword = false
    var onLoginSuccess: () -> Void
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(height: 200)
            
            Text("Welcome Runners")
                .font(.largeTitle)
                .bold()
                .padding(.bottom)
            
            VStack {
                TextField("E-mail", text: $email)
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
                
                Button(action: loginUser) {
                    Text("Login")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                .padding(.top)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .font(.footnote)
                }
                
            }
            .padding()
        }
    }
    
    func loginUser() {
        Task {
            do {
                try await AuthService.shared.login(email: email, password: password)
                print("Login successful")
                onLoginSuccess()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

//#Preview {
//    LoginView()
//}
