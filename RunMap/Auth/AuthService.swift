//
//  AuthService.swift
//  RunMap
//
//  Created by Aisha on 13.02.25.
//

import Foundation
import Supabase

struct Secrets {
    static let supbaseURL = URL(string: "https://pqbaaazoqcclwhhcwuxa.supabase.co")!
    static let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBxYmFhYXpvcWNjbHdoaGN3dXhhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0Mzk1ODEsImV4cCI6MjA1NTAxNTU4MX0.YwdyrZ0J1clSJmPuF56uVAae2biyi9eF29BpqH_PYWs"
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
    
    func magicLinkLogin(email: String) async throws {
        try await supabase.auth.signInWithOTP(
            email: email,
            redirectTo: URL(string: "com.run-map-fll://login-callback")!
            
            
        )
    }
    func handleOpenURL(url: URL) async throws {
        currentSesion = try await supabase.auth.session(from: url)
    }
    
    func logout() async throws {
        try await supabase.auth.signOut()
        currentSesion = nil
    }
}
