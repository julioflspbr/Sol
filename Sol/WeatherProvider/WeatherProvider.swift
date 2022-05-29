//
//  WeatherProvider.swift
//  Sol
//
//  Created by Júlio César Flores on 27/05/22.
//

import MapKit
import SwiftUI
import Foundation

protocol NetworkSession {
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {
}

final class WeatherProvider: ObservableObject {
    private let weatherService: WeatherService
    private let locale: LocaleService
    
    init(networkSession: NetworkSession = URLSession.shared, locale: LocaleService = LocaleService()) throws {
        self.weatherService = try WeatherService(networkSession: networkSession)
        self.locale = locale
    }
    
    func fetchWeather(coordinates: CLLocationCoordinate2D) async throws -> Weather {
        let response = try await self.weatherService.fetchCurrentWeather(coordinates: coordinates)
        return Weather(response: response, locale: self.locale)
    }
    
    func fetchForecast(coordinates: CLLocationCoordinate2D) async throws -> [Weather] {
        let response = try await self.weatherService.fetchForecast(coordinates: coordinates)
        return response.forecast.map({ Weather(response: $0, locale: self.locale) })
    }

    func fetchWeatherIcon(weather: Weather) async throws -> Image {
        try await self.weatherService.fetchWeatherIcon(weather.icon)
    }
}
