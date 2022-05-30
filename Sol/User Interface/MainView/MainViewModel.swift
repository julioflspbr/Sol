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
    // MARK: - static attributes
    private static let londonCoordinates = CLLocationCoordinate2D(latitude: 51.5072, longitude: 0.1276)
    
    private static let defaultSpan = CLLocationAccuracy(10000) // ten kilometers
    
    private static let defaultRegion = MKCoordinateRegion(center: londonCoordinates, latitudinalMeters: defaultSpan, longitudinalMeters: defaultSpan)

    // MARK: - internal attributes
    private var weatherDebouncer: Timer?

    private var loadingDebouncer: Timer?

    private let locationManager = CLLocationManager()

    // MARK: - published attributes
    @Published var isLoading = true

    @Published var location = defaultRegion

    @Published private(set) var weatherData = [Weather]()

    // MARK: - initialiser
    override init() {
        super.init()
        self.locationManager.delegate = self
    }

    deinit {
        self.weatherDebouncer?.invalidate()
    }

    // MARK: public interface
    func requestLocation() {
        if self.locationManager.authorizationStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        } else if self.locationManager.authorizationStatus.rawValue >= CLAuthorizationStatus.authorizedWhenInUse.rawValue {
            self.locationManager.requestLocation()
        } else {
            self.location = Self.defaultRegion
        }
    }

    func requestWeather(for coordinates: MKCoordinateRegion, weatherProvider: WeatherProvider) {
        self.weatherDebouncer?.invalidate()
        self.weatherDebouncer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [unowned self] _ in
            self.loadingDebouncer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [unowned self] _ in
                withAnimation {
                    self.isLoading = true
                }
            })

            Task {
                do {
                    async let weather = weatherProvider.fetchWeather(coordinates: coordinates.center)
                    async let forecast = weatherProvider.fetchForecast(coordinates: coordinates.center)
                    let weatherData = try await [weather] + forecast

                    await MainActor.run {
                        withAnimation {
                            self.weatherData = weatherData
                            self.loadingDebouncer?.invalidate()
                            self.isLoading = false
                        }
                    }
                } catch {
                    // TODO: error handling
                    print(error)
                }
            }
        })
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
