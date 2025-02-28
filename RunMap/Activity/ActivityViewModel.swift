//
//  ActivityViewModel.swift
//  RunMap
//
//  Created by Aisha on 28.02.25.
//

import Foundation
import Supabase

class ActivityViewModel: ObservableObject {
    @Published var activities: [RunPayload] = []

    func loadActivities() async {
        do {
            guard let userId = AuthService.shared.currentSesion?.user.id else { return }
            let fetchedActivities = try await DatabaseService.shared.fetchWorkouts(for: userId)
            DispatchQueue.main.async {
                self.activities = fetchedActivities.sorted(by: { $0.createdAt >= $1.createdAt })
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
 


}
