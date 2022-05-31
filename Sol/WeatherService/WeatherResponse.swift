//
//  WeatherResponse.swift
//  Sol
//
//  Created by Júlio César Flores on 26/05/22.
//

import Foundation

struct WeatherResponse: Decodable, DecodableWithConfiguration {
    let date: Date
    let city: String
    let country: String
    let visibility: Double
    let weather: String
    let description: String
    let icon: String
    let temperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    let realFeel: Double
    let pressure: Double
    let humidity: Double
    let windSpeed: Double
    let windDirection: Double
    
    // the following decode structure follows the Open Weather API documentation, found at at https://openweathermap.org/current (26th May 2022)
    enum WeatherCodingKey: String, CodingKey {
        case date = "dt"
        case name
        case city
        case weather
        case main
        case visibility
        case sys
        case wind
        
        enum Main: String, CodingKey {
            case temperature = "temp"
            case realFeel = "feels_like"
            case minTemperature = "temp_min"
            case maxTemperature = "temp_max"
            case pressure
            case humidity
        }
        
        enum City: String, CodingKey {
            case name
            case country
        }
        
        enum Wind: String, CodingKey {
            case speed
            case direction = "deg"
        }
        
        enum Sys: String, CodingKey {
            case country
        }
    }
    
    struct Weather: Decodable {
        let main: String
        let description: String
        let icon: String
    }
    
    struct ProvidedCity: Decodable {
        let name: String
        let country: String
    }
    
    /// Initialiser used for request endpoint `/weather`
    init(from decoder: Decoder) throws {
        let weather = try decoder.container(keyedBy: WeatherCodingKey.self)
        
        let timestamp = try weather.decode(TimeInterval.self, forKey: .date)
        self.date = Date(timeIntervalSince1970: timestamp)
        self.visibility = try weather.decode(Double.self, forKey: .visibility)
        self.city = try weather.decode(String.self, forKey: .name)
        
        let sys = try weather.nestedContainer(keyedBy: WeatherCodingKey.Sys.self, forKey: .sys)
        self.country = try sys.decode(String.self, forKey: .country)
        
        let weatherMeta = try weather.decode(Array<Weather>.self, forKey: .weather)
        self.weather = weatherMeta[0].main
        self.description = weatherMeta[0].description
        self.icon = weatherMeta[0].icon
        
        let main = try weather.nestedContainer(keyedBy: WeatherCodingKey.Main.self, forKey: .main)
        self.temperature = try main.decode(Double.self, forKey: .temperature)
        self.minTemperature = try main.decode(Double.self, forKey: .minTemperature)
        self.maxTemperature = try main.decode(Double.self, forKey: .maxTemperature)
        self.realFeel = try main.decode(Double.self, forKey: .realFeel)
        self.pressure = try main.decode(Double.self, forKey: .pressure)
        self.humidity = try main.decode(Double.self, forKey: .humidity)
        
        let wind = try weather.nestedContainer(keyedBy: WeatherCodingKey.Wind.self, forKey: .wind)
        self.windSpeed = try wind.decode(Double.self, forKey: .speed)
        self.windDirection = try wind.decode(Double.self, forKey: .direction)
    }
    
    /// Initialiser used for request endpoint `/forecast`
    init(from decoder: Decoder, configuration: ProvidedCity) throws {
        let weather = try decoder.container(keyedBy: WeatherCodingKey.self)
        
        let timestamp = try weather.decode(TimeInterval.self, forKey: .date)
        self.date = Date(timeIntervalSince1970: timestamp)
        self.visibility = try weather.decode(Double.self, forKey: .visibility)
        self.city = configuration.name
        self.country = configuration.country
        
        let weatherMeta = try weather.decode(Array<Weather>.self, forKey: .weather)
        self.weather = weatherMeta[0].main
        self.description = weatherMeta[0].description
        self.icon = weatherMeta[0].icon
        
        let main = try weather.nestedContainer(keyedBy: WeatherCodingKey.Main.self, forKey: .main)
        self.temperature = try main.decode(Double.self, forKey: .temperature)
        self.minTemperature = try main.decode(Double.self, forKey: .minTemperature)
        self.maxTemperature = try main.decode(Double.self, forKey: .maxTemperature)
        self.realFeel = try main.decode(Double.self, forKey: .realFeel)
        self.pressure = try main.decode(Double.self, forKey: .pressure)
        self.humidity = try main.decode(Double.self, forKey: .humidity)
        
        let wind = try weather.nestedContainer(keyedBy: WeatherCodingKey.Wind.self, forKey: .wind)
        self.windSpeed = try wind.decode(Double.self, forKey: .speed)
        self.windDirection = try wind.decode(Double.self, forKey: .direction)
    }
}
