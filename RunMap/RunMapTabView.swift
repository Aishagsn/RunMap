//
//  RunMapTabView.swift
//  RunMap
//
//  Created by Aisha on 10.02.25.
//

import SwiftUI

struct RunMapTabView: View {
    @State var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView().tag(0)
                .tabItem {
                    Image(systemName: "figure.run")
                    
                    Text("Run")
                }
            
        }
    }
}

#Preview {
    RunMapTabView()
}
