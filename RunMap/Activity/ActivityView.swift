//
//  ActivityView.swift
//  RunMap
//
//  Created by Aisha on 17.02.25.
//

import SwiftUI

struct ActivityView: View {
    @StateObject private var viewModel = ActivityViewModel()
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Verifying session...")
                } else {
                    List {
                        ForEach(viewModel.activities) { run in
                            NavigationLink {
                                ActivityItemView(run: run)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(run.createdAt.timeOfDayString())
                                        .font(.title3)
                                        .bold()
                                    
                                    Text(run.createdAt.formatDate())
                                        .font(.caption)
                                    
                                    HStack(spacing: 24) {
                                        VStack(alignment: .leading) {
                                            Text("Distance")
                                                .font(.caption)
                                            
                                            Text("\(run.distance / 1000, specifier: "%.2f") km")
                                                .font(.headline)
                                                .bold()
                                        }
                                        
                                        VStack {
                                            Text("Pace")
                                                .font(.caption)
                                            
                                            Text("\(run.pace, specifier: "%.2f") min")
                                                .font(.headline)
                                                .bold()
                                        }
                                        
                                        VStack {
                                            Text("Time")
                                                .font(.caption)
                                            
                                            Text("\(run.time.convertDurationToString())")
                                                .font(.headline)
                                                .bold()
                                        }
                                    }
                                    .padding(.vertical)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle("Activity")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(role: .destructive) {
                                Task {
                                    do {
                                        try await AuthService.shared.logout()
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            } label: {
                                Text("Logout")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    .onAppear {
                        Task {
                            
                            do {
                                guard let userId = AuthService.shared.currentSesion?.user.id else { return }
                                viewModel.activities = try await
                                DatabaseService.shared.fetchWorkouts(for: userId)
                                viewModel.activities.sort(by: { $0.createdAt >= $1.createdAt })
                                
                            } catch {
                                print(error.localizedDescription)
                            }
                            await viewModel.loadActivities()
                        }
                        
                    }
                }
            }
        }
        .task {
            await checkSessionBeforeLoading()
        }
    }
   
        func checkSessionBeforeLoading() async {
            while AuthService.shared.currentSesion == nil {
                try? await Task.sleep(nanoseconds: 500_000_000)
            }
            isLoading = false
            await viewModel.loadActivities()
        }
}



//#Preview {
//    ActivityView()
//}
