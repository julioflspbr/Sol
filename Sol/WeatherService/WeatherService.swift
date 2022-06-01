//
//  WeatherService.swift
//  Sol
//
//  Created by Júlio César Flores on 26/05/22.
//

import MapKit
import SwiftUI
import Foundation

protocol NetworkSession {
    func data(for: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {
}

final class WeatherService {
    private static let timeout: TimeInterval = 10.0

    enum Error: Swift.Error {
        case missingApiURL
        case missingIconURL
        case missingApiKey
        case malFormedURL
        case badIconWeather
    }
    
    private let networkSession: NetworkSession

    private let locale: LocaleService
    
    let apiURL: String

    let iconURL: String
    
    let apiKey: String
    
    init(networkSession: NetworkSession, locale: LocaleService) throws {
        guard let apiURL = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_URL") as? String else {
            throw Error.missingApiURL
        }
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String else {
            throw Error.missingApiKey
        }
        guard let iconURL = Bundle.main.object(forInfoDictionaryKey: "WEATHER_ICON_URL") as? String else {
            throw Error.missingIconURL
        }
        
        self.apiURL = apiURL
        self.iconURL = iconURL
        self.apiKey = apiKey
        self.networkSession = networkSession
        self.locale = locale
    }
    
    func fetchCurrentWeather(coordinates: CLLocationCoordinate2D) async throws -> WeatherResponse {
        let latitude = String(coordinates.latitude)
        let longitude = String(coordinates.longitude)
        guard let url = URL(string: "\(self.apiURL)/weather?lat=\(latitude)&lon=\(longitude)&lang=\(self.locale.language)&appid=\(self.apiKey)") else {
            throw Error.malFormedURL
        }
        let urlRequest = URLRequest(url: url, timeoutInterval: Self.timeout)
        let (data, _) = try await self.networkSession.data(for: urlRequest, delegate: nil)
        
        let decoder = JSONDecoder()
        let weather = try decoder.decode(WeatherResponse.self, from: data)
        
        return weather
    }
    
    func fetchForecast(coordinates: CLLocationCoordinate2D) async throws -> ForecastResponse {
        let latitude = String(coordinates.latitude)
        let longitude = String(coordinates.longitude)
        guard let url = URL(string: "\(self.apiURL)/forecast?lat=\(latitude)&lon=\(longitude)&lang=\(self.locale.language)&appid=\(self.apiKey)") else {
            throw Error.malFormedURL
        }
        let urlRequest = URLRequest(url: url, timeoutInterval: Self.timeout)
        let (data, _) = try await self.networkSession.data(for: urlRequest, delegate: nil)
        
        let decoder = JSONDecoder()
        let weather = try decoder.decode(ForecastResponse.self, from: data)
        
        return weather
    }

    func fetchWeatherIcon(_ icon: String) async throws -> Image {
        guard let url = URL(string: "\(self.iconURL)/\(icon)@2x.png") else {
            throw Error.malFormedURL
        }

        let urlRequest = URLRequest(url: url, timeoutInterval: Self.timeout)
        let (data, _) = try await self.networkSession.data(for: urlRequest, delegate: nil)
        guard let image = UIImage(data: data) else {
            throw Error.badIconWeather
        }

        return Image(uiImage: image)
    }
}
