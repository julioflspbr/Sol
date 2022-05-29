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

    init() {
        do {
            self.weatherProvider = try WeatherProvider()
        } catch {
            // The only possible error is missing Info.plist entries
            fatalError("ERROR: There are missing keys in Info.plist: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(weatherProvider)
        }
    }
}
