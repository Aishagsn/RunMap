//
//  RunView.swift
//  RunMap
//
//  Created by Aisha on 10.02.25.
//

import SwiftUI
import AudioToolbox

struct RunView: View {
    @EnvironmentObject var runTracker: RunTracker
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("\(runTracker.distance, specifier: "%.2f") m")
                        .font(.title)
                        .bold()
                    
                    Text("Distance")
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("BPM")
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("\(runTracker.pace, specifier: "%.2f") min / km")
                        .font(.title)
                        .bold()
                    Text("Pace")
                }
                .frame(maxWidth: .infinity)
            }
            
            VStack {
                Text("\(runTracker.elapsedTime.convertDurationToString())")
                    .font(.system(size: 64))
                
                Text("Time")
                    .foregroundStyle(.gray)
            }
            .frame(maxHeight: .infinity)
            
            HStack {
                Button {
                    withAnimation {
                        runTracker.stopRun()
                        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
                    }
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(.black)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    runTracker.pauseRun()
                } label: {
                    Image(systemName: "pause.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(.black)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(.yellow)
    }
}

#Preview {
    RunView()
        .environmentObject(RunTracker())
}
