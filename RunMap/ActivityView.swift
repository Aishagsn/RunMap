//
//  ActivityView.swift
//  RunMap
//
//  Created by Aisha on 17.02.25.
//

import SwiftUI

struct ActivityView: View {
    @State var activities = [RunPayload]()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(activities) { run in
                    HStack {
                        Text("\(run.distance / 1000) km")
                        
                        Text("\(run.createdAt.formatted())")
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Activity")
            .onAppear {
                Task {
                    do {
                        activities = try await DatabaseService.shared.fetchWorkouts()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    ActivityView()
}
