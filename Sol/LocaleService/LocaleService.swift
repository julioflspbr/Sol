//
//  LocaleService.swift
//  Sol
//
//  Created by Júlio César Flores on 27/05/22.
//

import AVFAudio
import Foundation

final class LocaleService: ObservableObject {
    static let weatherStandards = UnitSystem(temperature: .kelvin, pressure: .hectopascals, distance: .meters, speed: .metersPerSecond)
    
    static let metricStandards = UnitSystem(temperature: .celsius, pressure: .hectopascals, distance: .kilometers, speed: .kilometersPerHour)
    
    static let imperialStandards = UnitSystem(temperature: .fahrenheit, pressure: .inchesOfMercury, distance: .miles, speed: .milesPerHour)

    private let locale: Locale
    
    private let localBundle: Bundle
    
    let unitSystem: UnitSystem

    let timeZone: TimeZone

    lazy private(set) var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = self.locale
        formatter.numberStyle = .spellOut
        return formatter
    }()

    lazy private(set) var measurementFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.locale = self.locale
        formatter.unitStyle = .long
        return formatter
    }()

    lazy private(set) var voice = AVSpeechSynthesisVoice(language: self.locale.identifier)

    var language: String {
        self.locale.languageCode ?? "en"
    }

    var isMetric: Bool {
        self.locale.usesMetricSystem
    }
    
    init(locale: Locale = .current, timeZone: TimeZone = .current) {
        let localPath: String

        if let language = locale.languageCode, let region = locale.regionCode, Bundle.main.localizations.contains("\(language)-\(region)") {
            self.locale = locale
            guard let path = Bundle.main.path(forResource: "\(language)-\(region)", ofType: "lproj") else {
                fatalError("Localisation bundle path is not valid")
            }
            localPath = path
        } else if let language = locale.languageCode, let code = Bundle.main.localizations.sorted().first(where: { $0.starts(with: language) }) {
            self.locale = locale
            guard let path = Bundle.main.path(forResource: code, ofType: "lproj") else {
                fatalError("Localisation bundle path is not valid")
            }
            localPath = path
        } else {
            self.locale = Locale(identifier: "en-GB")
            guard let path = Bundle.main.path(forResource: "en-GB", ofType: "lproj") else {
                fatalError("Localisation bundle path is not valid")
            }
            localPath = path
        }
        

        guard let localBundle = Bundle(path: localPath) else {
            fatalError("Localisation bundle not found")
        }
        
        self.localBundle = localBundle
        self.timeZone = timeZone
        
        if self.locale.usesMetricSystem {
            self.unitSystem = Self.metricStandards
        } else {
            self.unitSystem = Self.imperialStandards
        }
    }
    
    subscript(_ key: String) -> String {
        self.localBundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
