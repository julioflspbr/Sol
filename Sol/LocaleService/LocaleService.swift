//
//  LocaleService.swift
//  Sol
//
//  Created by Júlio César Flores on 27/05/22.
//

import Foundation

final class LocaleService {
    static let weatherStandards = UnitSystem(temperature: .kelvin, pressure: .hectopascals, distance: .meters, speed: .metersPerSecond)
    
    static let metricStandards = UnitSystem(temperature: .celsius, pressure: .hectopascals, distance: .meters, speed: .kilometersPerHour)
    
    static let imperialStandards = UnitSystem(temperature: .fahrenheit, pressure: .millibars, distance: .miles, speed: .milesPerHour)
    
    private let locale: Locale
    
    private let localBundle: Bundle
    
    var unitSystem: UnitSystem {
        if self.locale.usesMetricSystem {
            return Self.metricStandards
        } else {
            return Self.imperialStandards
        }
    }
    
    init(locale: Locale = .current) {
        if Bundle.main.localizations.contains(locale.identifier) {
            self.locale = locale
        } else {
            self.locale = Locale(identifier: "en-GB")
        }
        
        guard let localPath = Bundle.main.path(forResource: self.locale.identifier, ofType: "lproj") else {
            fatalError("Localisation bundle path is not valid")
        }
        guard let localBundle = Bundle(path: localPath) else {
            fatalError("Localisation bundle not found")
        }
        
        self.localBundle = localBundle
    }
    
    subscript(_ key: String) -> String {
        self.localBundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
