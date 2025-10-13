//
//  LocationManager.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-13.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D? // The published user location
    @Published var authorizationStatus: CLAuthorizationStatus? // Optional: track permission
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Request permission
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    // Called when the authorization changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    // Called when location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first?.coordinate
    }
    
    // Optional: handle errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
