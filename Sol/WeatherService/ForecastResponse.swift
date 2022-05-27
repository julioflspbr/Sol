//
//  ForecastResponse.swift
//  Sol
//
//  Created by Júlio César Flores on 26/05/22.
//

import Foundation

struct ForecastResponse: Decodable {
    let forecast: [WeatherResponse]
    
    enum ForecastWeatherResponse: String, CodingKey {
        case list
        case city
    }
    
    init(from decoder: Decoder) throws {
        let forecast = try decoder.container(keyedBy: ForecastWeatherResponse.self)
        let city = try forecast.decode(WeatherResponse.ProvidedCity.self, forKey: .city)
        
        self.forecast = try forecast.decode(Array<WeatherResponse>.self, forKey: .list, configuration: city)
    }
}
