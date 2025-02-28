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
    let route: [GeoJSONCoordinate]
    
    enum CodingKeys: String, CodingKey {
        case id, distance, pace, time, route
        case createdAt = "created_at"
        case userId = "user_id"
    }
}

struct GeoJSONCoordinate: Codable {
    let longtitude: Double
    let latitude: Double
}

final class DatabaseService {
    
    static let shared = DatabaseService()
    
    private var supabase = SupabaseClient(supabaseURL: Secrets.supbaseURL, supabaseKey: Secrets.supabaseKey)
    
    private init() { }
    
    //CRUD
    
//    //Create
//    func saveWorkout(run: RunPayload) async throws {
//        let _ = try await supabase.from(Table.workouts).insert(run).execute().value
//    }
//    
//    //Reading
//    func fetchWorkouts(for userId: UUID)  async throws -> [RunPayload] {
//        return try await supabase.from(Table.workouts).select().in("user_id", values: [userId]).execute().value
//        
//    }
    
    func saveWorkout(run: RunPayload) async throws {
        do {
            let _ = try await supabase.from(Table.workouts).insert(run).execute().value
            print("Workout successfully saved")
        } catch {
            print("Error saving workout: \(error.localizedDescription)")
            throw error
        }
    }
    
//    func fetchWorkouts(for userId: UUID) async throws -> [RunPayload] {
//        let response = try await supabase
//            .from(Table.workouts)
//            .select()
//            .in("user_id", values: [userId])
//            .execute()
//
//        guard let data = response.value as? [RunPayload] else {
//            throw NSError(domain: "SupabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse workouts"])
//        }
//        
//        return data
//    }
    func fetchWorkouts(for userId: UUID) async throws -> [RunPayload] {
        do {
            let response = try await supabase
                .from(Table.workouts)
                .select()
                .eq("user_id", value: userId)
                .execute()
            
            print("Raw Supabase Response: \(response)")

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            
            let workouts = try decoder.decode([RunPayload].self, from: response.data)

            return workouts
        } catch {
            print("Error fetching workouts: \(error.localizedDescription)")
            throw error
        }
    }




}

