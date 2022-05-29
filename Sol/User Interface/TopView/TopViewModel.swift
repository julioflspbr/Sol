//
//  TopViewModel.swift
//  Sol
//
//  Created by Júlio César Flores on 29/05/22.
//

import SwiftUI
import Foundation

final class TopViewModel: ObservableObject {
    @Published private(set) var weatherIcon: Image?

    func fetchWeatherIcon(provider: WeatherProvider, weather: Weather) {
        Task {
            do {
                let icon = try await provider.fetchWeatherIcon(weather: weather)
                await MainActor.run {
                    self.weatherIcon = icon
                }
            } catch {
                print("WARNING: failed to download weather icon: \(error)")
                await MainActor.run {
                    self.weatherIcon = Theme.Image.weatherFallback
                }
            }
        }
    }
}
