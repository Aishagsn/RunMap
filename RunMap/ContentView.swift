//
//  ContentView.swift
//  RunMap
//
//  Created by Aisha on 10.02.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if let session = AuthService.shared.currentSesion {
            RunMapTabView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
