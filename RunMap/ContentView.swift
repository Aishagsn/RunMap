//
//  ContentView.swift
//  RunMap
//
//  Created by Aisha on 10.02.25.
//

import SwiftUI

struct ContentView: View {
    @State private var isRegistered = false
//    @State private var isLoggedIn = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            if isLoggedIn {
                RunMapTabView()
            } else if isRegistered {
                LoginView(onLoginSuccess: {
                    isLoggedIn = true
                })
            } else {
                RegisterView(onRegisterSuccess: {
                    isRegistered = true
                })
            }
        }
    }
}

#Preview {
    ContentView()
}
