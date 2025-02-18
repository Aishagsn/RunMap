//
//  AuthService.swift
//  RunMap
//
//  Created by Aisha on 13.02.25.
//

import Foundation
import Supabase

struct Secrets {
    static let supbaseURL = URL(string: "https://sknizpprtmsnwkfpvspg.supabase.co")!
    static let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNrbml6cHBydG1zbndrZnB2c3BnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk3ODU4MzIsImV4cCI6MjA1NTM2MTgzMn0.X9bSJJSaLHFmYd9rmjZaKa0ZJmRnjxZyLajwK_WNsYs"
}

@Observable
final class AuthService {
    
    static let shared = AuthService()
    private var supabase = SupabaseClient(supabaseURL: Secrets.supbaseURL, supabaseKey: Secrets.supabaseKey)
    
    var currentSesion: Session?
    
    private init () {
        Task {
            currentSesion = try? await  supabase.auth.session
        }
    }
    
    func register(email: String, password: String) async throws {
        try await supabase.auth.signUp(email: email, password: password)
    }
    
    func login(email: String, password: String) async throws {
        try await supabase.auth.signIn(email: email, password: password)
    }
    
    func logout() async throws {
        try await supabase.auth.signOut()
        currentSesion = nil
    }
}
