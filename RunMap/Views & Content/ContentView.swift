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
                    .task {
                        do {
                            try await HealthManager.shared.requestAuthorization()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
            } else if isRegistered {
                LoginView(onLoginSuccess: {
                    isLoggedIn = true
                    Task {
                        do {
                            try await HealthManager.shared.requestAuthorization()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                })
            } else {
                RegisterView(onRegisterSuccess: {
                    isRegistered = true
                })
            }
        }
    }
}



//#Preview {
//    ContentView()
//}
