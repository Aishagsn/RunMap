//
//  DatabaseService.swift
//  RunMap
//
//  Created by Aisha on 13.02.25.
//

import Foundation
import Supabase

struct Table {
    static let workouts = "workouts"
}

struct RunPayload: Identifiable, Codable {
    var id: Int?
    var createdAt: Date
    var userId: UUID
    var distance: Double
    var pace: Double
    var time: Int
    
    enum CodingKeys: String, CodingKey {
        case id, distance, pace, time
        case createdAt = "created_at"
        case userId = "user_id"
    }
}

final class DatabaseService {
    
    static let shared = DatabaseService()
    
    private var supabase = SupabaseClient(supabaseURL: Secrets.supbaseURL, supabaseKey: Secrets.supabaseKey)
    
    private init() { }
    
    //CRUD
    
    //Create
    func saveWorkout(run: RunPayload) async throws {
        let _ = try await supabase.from(Table.workouts).insert(run).execute().value
    }
    
    //Reading
    func fetchWorkouts()  async throws -> [RunPayload] {
        return try await supabase.from(Table.workouts).select().execute().value
        
    }
}
