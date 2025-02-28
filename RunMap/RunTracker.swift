//
//  RunTracker.swift
//  RunMap
//
//  Created by Aisha on 10.02.25.
//

import Foundation
import MapKit

//@Observable
class RunTracker: NSObject, ObservableObject {
    @Published var region = MKCoordinateRegion(center: .init(latitude: 40.390098, longitude: 49.861414), span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    @Published var isRunning
    = false
    @Published var presentCountdown = false
    @Published var presentRunView = false
    @Published var presentPauseView = false
    @Published var pace = 0.0
    @Published var distance = 0.0
    @Published var elapsedTime = 0
    @Published var locations = [CLLocationCoordinate2D]()
    
    private var timer: Timer?
    
    //Location Tracking
    private var locationManager: CLLocationManager?
    private var startlocation: CLLocation?
    private var lastLocation: CLLocation?
    
    override init() {
        super.init()
        
        Task {
            await MainActor.run {
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.requestWhenInUseAuthorization()
                locationManager?.startUpdatingLocation()
            }
        }
    }
    
    func startRun() {
        presentRunView = true
        isRunning = true
        startlocation = nil
        lastLocation = nil
        distance = 0.0
        pace = 0.0
        elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.elapsedTime += 1
            if self.distance > 0 {
                pace = (Double(self.elapsedTime) / 60)  / (self.distance / 1000)
            }
        }
        locationManager?.startUpdatingLocation()
    }
    
    func resumeRun() {
        isRunning = true
        presentPauseView = false
        presentRunView = true
        startlocation = nil
        lastLocation = nil
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.elapsedTime += 1
            if self.distance > 0 {
                pace = (Double(self.elapsedTime) / 60)  / (self.distance / 1000)
            }
        }
        locationManager?.startUpdatingLocation()
        
    }
    
    func pauseRun() {
        isRunning = false
        presentRunView = false
        presentPauseView = true
        locationManager?.stopUpdatingLocation()
        timer?.invalidate()
    }
    
    func stopRun() {
        isRunning = false
        presentRunView = false
        presentPauseView = false
        locationManager?.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
        postToDatabase()
    }
    
    func postToDatabase() {
        Task {
            do {
                guard let userId = AuthService.shared.currentSesion?.user.id else { return }
                let run = RunPayload(createdAt: .now, userId: userId, distance: distance, pace: pace, time: elapsedTime, route: convertToGeoJSONCoordinates(locations: locations))
                try await DatabaseService.shared.saveWorkout(run: run)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


// MARK: Location Tracking
extension RunTracker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.region.center = location.coordinate
        }
        
        Task {
            await MainActor.run {
                region.center = location.coordinate
            }
        }
        
        self.locations.append(location.coordinate)
        
        if startlocation == nil {
            startlocation = location
            lastLocation = location
            return
        }
        
        if let lastLocation {
            distance += lastLocation.distance(from: location)
        }
        lastLocation = location
    }
}

func convertToGeoJSONCoordinates(locations: [CLLocationCoordinate2D]) -> [GeoJSONCoordinate] {
    return locations.map { GeoJSONCoordinate(longtitude: $0.longitude, latitude: $0.latitude) }
}
