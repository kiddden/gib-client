//
//  LocationService.swift
//  gib-client
//
//  Created by Eugene Ned on 06.04.2023.
//

import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var onLocationUpdate: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startUpdatingLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus = manager.authorizationStatus
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            onLocationUpdate?(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error updating location: \(error.localizedDescription)")
    }
}
