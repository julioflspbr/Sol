//
//  TopViewModel.swift
//  Sol
//
//  Created by Júlio César Flores on 29/05/22.
//

import SwiftUI
import Foundation

final class TopViewModel: ObservableObject {
    private static let errorImage = Image(systemName: "exclamationmark.icloud")

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
                weatherIcon = Self.errorImage
            }
        }
    }
}
