//
//  WeatherService.swift
//  Sol
//
//  Created by Júlio César Flores on 26/05/22.
//

import MapKit
import Foundation

final class WeatherService {
    enum Error: Swift.Error {
        case missingApiURL
        case missingApiKey
        case malFormedURL
    }
    
    private let networkSession: NetworkSession
    
    let apiURL: String
    
    let apiKey: String
    
    init(networkSession: NetworkSession) throws {
        guard let apiURL = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_URL") as? String else {
            throw Error.missingApiURL
        }
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String else {
            throw Error.missingApiKey
        }
        
        self.apiURL = apiURL
        self.apiKey = apiKey
        self.networkSession = networkSession
    }
    
    func fetchCurrentWeather(coordinates: CLLocationCoordinate2D) async throws -> WeatherResponse {
        let latitude = String(coordinates.latitude)
        let longitude = String(coordinates.longitude)
        guard let url = URL(string: "\(self.apiURL)/weather?lat=\(latitude)&lon=\(longitude)&appid=\(self.apiKey)") else {
            throw Error.malFormedURL
        }
        let (data, _) = try await self.networkSession.data(from: url, delegate: nil)
        
        let decoder = JSONDecoder()
        let weather = try decoder.decode(WeatherResponse.self, from: data)
        
        return weather
    }
    
    func fetchForecast(coordinates: CLLocationCoordinate2D) async throws -> ForecastResponse {
        let latitude = String(coordinates.latitude)
        let longitude = String(coordinates.longitude)
        guard let url = URL(string: "\(self.apiURL)/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(self.apiKey)") else {
            throw Error.malFormedURL
        }
        let (data, _) = try await self.networkSession.data(from: url, delegate: nil)
        
        let decoder = JSONDecoder()
        let weather = try decoder.decode(ForecastResponse.self, from: data)
        
        return weather
    }
}
