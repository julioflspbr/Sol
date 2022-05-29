//
//  WeatherServiceTests.swift
//  SolTests
//
//  Created by Júlio César Flores on 26/05/22.
//

import XCTest
import MapKit
import SwiftUI
@testable import Sol

final class WeatherRequests: XCTestCase {
    enum Error: Swift.Error {
        case decode
        case missingApiURL
        case missingApiKey
    }
    
    let appBundle = Bundle.main
    let testBundle = Bundle(for: ResponseDecoding.self)

    func testWeatherRequest() async throws {
        // provided
        guard let path = self.testBundle.url(forResource: "weather", withExtension: "json") else {
            throw Error.decode
        }
        guard let apiURL = self.appBundle.object(forInfoDictionaryKey: "WEATHER_API_URL") as? String else {
            throw Error.missingApiURL
        }
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String else {
            throw Error.missingApiKey
        }
        
        let data = try Data(contentsOf: path)
        let network = NetworkMock(response: data)
        let service = try WeatherService(networkSession: network)
        let coordinates = CLLocationCoordinate2D(latitude: 55.6178, longitude: 12.5702)
        
        // when
        let weather = try await service.fetchCurrentWeather(coordinates: coordinates)
        
        // then
        XCTAssertEqual(network.queriedURL?.absoluteString, "\(apiURL)/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(apiKey)")
        XCTAssertEqual(weather.date, Date(timeIntervalSince1970: 1653577971))
        XCTAssertEqual(weather.city, "Tårnby Kommune")
        XCTAssertEqual(weather.country, "DK")
        XCTAssertEqual(weather.visibility, 10000)
        XCTAssertEqual(weather.weather, "Clouds")
        XCTAssertEqual(weather.icon, "03d")
        XCTAssertEqual(weather.temperature, 287.4)
        XCTAssertEqual(weather.minTemperature, 287.06)
        XCTAssertEqual(weather.maxTemperature, 288.46)
        XCTAssertEqual(weather.realFeel, 286.86)
        XCTAssertEqual(weather.pressure, 1011)
        XCTAssertEqual(weather.humidity, 76)
        XCTAssertEqual(weather.windSpeed, 2.24)
        XCTAssertEqual(weather.windDirection, 305)
    }
    
    func testForecastRequest() async throws {
        // provided
        guard let path = self.testBundle.url(forResource: "forecast", withExtension: "json") else {
            throw Error.decode
        }
        guard let apiURL = self.appBundle.object(forInfoDictionaryKey: "WEATHER_API_URL") as? String else {
            throw Error.missingApiURL
        }
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String else {
            throw Error.missingApiKey
        }
        
        let data = try Data(contentsOf: path)
        let network = NetworkMock(response: data)
        let service = try WeatherService(networkSession: network)
        let coordinates = CLLocationCoordinate2D(latitude: 55.6178, longitude: 12.5702)
        
        // when
        let forecast = try await service.fetchForecast(coordinates: coordinates)
        
        // then
        XCTAssertEqual(network.queriedURL?.absoluteString, "\(apiURL)/forecast?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(apiKey)")
        
        XCTAssertEqual(forecast.forecast[0].date, Date(timeIntervalSince1970: 1653577200))
        XCTAssertEqual(forecast.forecast[0].city, "Tårnby Kommune")
        XCTAssertEqual(forecast.forecast[0].country, "DK")
        XCTAssertEqual(forecast.forecast[0].visibility, 10000)
        XCTAssertEqual(forecast.forecast[0].weather, "Rain")
        XCTAssertEqual(forecast.forecast[0].icon, "10d")
        XCTAssertEqual(forecast.forecast[0].temperature, 286.72)
        XCTAssertEqual(forecast.forecast[0].minTemperature, 286.72)
        XCTAssertEqual(forecast.forecast[0].maxTemperature, 287.64)
        XCTAssertEqual(forecast.forecast[0].realFeel, 286.09)
        XCTAssertEqual(forecast.forecast[0].pressure, 1011)
        XCTAssertEqual(forecast.forecast[0].humidity, 75)
        XCTAssertEqual(forecast.forecast[0].windSpeed, 10.31)
        XCTAssertEqual(forecast.forecast[0].windDirection, 272)
        
        XCTAssertEqual(forecast.forecast[1].date, Date(timeIntervalSince1970: 1653588000))
        XCTAssertEqual(forecast.forecast[1].city, "Tårnby Kommune")
        XCTAssertEqual(forecast.forecast[1].country, "DK")
        XCTAssertEqual(forecast.forecast[1].visibility, 10000)
        XCTAssertEqual(forecast.forecast[1].weather, "Clouds")
        XCTAssertEqual(forecast.forecast[1].icon, "04d")
        XCTAssertEqual(forecast.forecast[1].temperature, 286.54)
        XCTAssertEqual(forecast.forecast[1].minTemperature, 286.18)
        XCTAssertEqual(forecast.forecast[1].maxTemperature, 286.54)
        XCTAssertEqual(forecast.forecast[1].realFeel, 285.81)
        XCTAssertEqual(forecast.forecast[1].pressure, 1011)
        XCTAssertEqual(forecast.forecast[1].humidity, 72)
        XCTAssertEqual(forecast.forecast[1].windSpeed, 9.12)
        XCTAssertEqual(forecast.forecast[1].windDirection, 270)
        
        XCTAssertEqual(forecast.forecast[2].date, Date(timeIntervalSince1970: 1653598800))
        XCTAssertEqual(forecast.forecast[2].city, "Tårnby Kommune")
        XCTAssertEqual(forecast.forecast[2].country, "DK")
        XCTAssertEqual(forecast.forecast[2].visibility, 8670)
        XCTAssertEqual(forecast.forecast[2].weather, "Sun")
        XCTAssertEqual(forecast.forecast[2].icon, "03n")
        XCTAssertEqual(forecast.forecast[2].temperature, 285.07)
        XCTAssertEqual(forecast.forecast[2].minTemperature, 284.24)
        XCTAssertEqual(forecast.forecast[2].maxTemperature, 285.07)
        XCTAssertEqual(forecast.forecast[2].realFeel, 284.25)
        XCTAssertEqual(forecast.forecast[2].pressure, 1010)
        XCTAssertEqual(forecast.forecast[2].humidity, 74)
        XCTAssertEqual(forecast.forecast[2].windSpeed, 7.92)
        XCTAssertEqual(forecast.forecast[2].windDirection, 259)
    }

    func testFetchWeatherIcon() async throws {
        // provided
        guard let iconURL = self.appBundle.object(forInfoDictionaryKey: "WEATHER_ICON_URL") as? String else {
            throw Error.missingApiURL
        }
        guard let weatherPath = self.testBundle.url(forResource: "weather", withExtension: "json") else {
            throw Error.decode
        }
        guard let imagePath = self.testBundle.url(forResource: "weatherIcon", withExtension: "png") else {
            throw Error.decode
        }

        let weatherData = try Data(contentsOf: weatherPath)
        let imageData = try Data(contentsOf: imagePath)

        let decoder = JSONDecoder()
        let response = try decoder.decode(WeatherResponse.self, from: weatherData)
        let weather = Weather(response: response, locale: LocaleService())
        let network = NetworkMock(response: imageData)
        let weatherProvider = try WeatherProvider(networkSession: network, locale: LocaleService())

        // when
        _ = try await weatherProvider.fetchWeatherIcon(weather: weather)

        // then
        XCTAssertEqual(network.queriedURL?.absoluteString, "\(iconURL)/03d@2x.png")
    }
}
