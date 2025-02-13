//
//  HomeView.swift
//  RunMap
//
//  Created by Aisha on 10.02.25.
//

import SwiftUI
import MapKit


struct AreaMap: View {
    @Binding var region: MKCoordinateRegion
    var body: some View {
        let binding = Binding(
            get: { self.region },
            set: { newValue in
                DispatchQueue.main.async {
                    self.region = newValue
                }
            }
        )
        return Map(coordinateRegion: binding)
            .ignoresSafeArea()
    }
}


struct HomeView: View {
    @StateObject var runTracker = RunTracker()
    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .bottom) {
                    AreaMap(region: $runTracker.region)
                    
                    Button{
                        runTracker.presentCountdown = true
                    } label: {
                        Text("Start")
                            .bold()
                            .font(.title)
                            .foregroundStyle(.black)
                            .padding(36)
                            .background(.yellow)
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 40)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("Run")
            .fullScreenCover(isPresented: $runTracker.presentCountdown, content: {
                CountdownView()
                    .environmentObject(runTracker)
            })
            .fullScreenCover(isPresented: $runTracker.presentRunView, content: {
                RunView()
                    .environmentObject(runTracker)
            })
            .fullScreenCover(isPresented: $runTracker.presentPauseView, content: {
                PauseView()
                    .environmentObject(runTracker)
            })
        }
    }
}

#Preview {
    HomeView()
}
