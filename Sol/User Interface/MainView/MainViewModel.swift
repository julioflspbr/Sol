//
//  MainViewModel.swift
//  Sol
//
//  Created by Júlio César Flores on 28/05/22.
//

import MapKit
import SwiftUI
import Foundation
import CoreLocation

final class MainViewModel: NSObject, ObservableObject {
    private static let londonCoordinates = CLLocationCoordinate2D(latitude: 51.5072, longitude: 0.1276)
    
    private static let defaultSpan = CLLocationAccuracy(10000) // ten kilometers
    
    static let defaultRegion = MKCoordinateRegion(center: londonCoordinates, latitudinalMeters: defaultSpan, longitudinalMeters: defaultSpan)
    
    private let locationManager = CLLocationManager()
    
    @Published var location = defaultRegion
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    func requestLocation() {
        if self.locationManager.authorizationStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        } else if self.locationManager.authorizationStatus.rawValue >= CLAuthorizationStatus.authorizedWhenInUse.rawValue {
            self.locationManager.requestLocation()
        } else {
            self.location = Self.defaultRegion
        }
    }
}

extension MainViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus != .notDetermined else {
            return
        }
        guard manager.authorizationStatus.rawValue >= CLAuthorizationStatus.authorizedWhenInUse.rawValue else {
            self.location = Self.defaultRegion
            return
        }
        
        manager.desiredAccuracy = kCLLocationAccuracyReduced
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            self.location = Self.defaultRegion
            return  
        }
        
        let coordinates = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: Self.defaultSpan, longitudinalMeters: Self.defaultSpan)
        self.location = region
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: error handling
    }
}
