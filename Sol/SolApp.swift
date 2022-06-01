//
//  SolApp.swift
//  Sol
//
//  Created by Júlio César Flores on 26/05/22.
//

import SwiftUI

@main
struct SolApp: App {
    let weatherProvider: WeatherProvider

    let localeService: LocaleService

    @State private var isHandlingError: Bool = false

    init() {
        do {
            self.weatherProvider = try WeatherProvider()
            self.localeService = LocaleService()
        } catch {
            // The only possible error is missing Info.plist entries
            fatalError("ERROR: There are missing keys in Info.plist: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .handleError($isHandlingError, locale: localeService)
                .environmentObject(weatherProvider)
                .environmentObject(localeService)
        }
    }
}
