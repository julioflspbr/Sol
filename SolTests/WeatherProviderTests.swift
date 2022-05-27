//
//  WeatherProviderTests.swift
//  SolTests
//
//  Created by Júlio César Flores on 27/05/22.
//

import XCTest
import MapKit
@testable import Sol

class WeatherProviderTests: XCTestCase {
    enum Error: Swift.Error {
        case decode
    }
    
    let bundle = Bundle(for: WeatherProviderTests.self)
    
    func testFetchWeather() async throws {
        // provided
        guard let path = self.bundle.url(forResource: "weather", withExtension: "json") else {
            throw Error.decode
        }
        
        let data = try Data(contentsOf: path)
        let metricLocale = LocaleService(locale: Locale(identifier: "en-GB"))
        let network = NetworkMock(response: data)
        let weatherProvider = try WeatherProvider(networkSession: network, locale: metricLocale)
        let dummyCoords = CLLocationCoordinate2D(latitude: 55.6178, longitude: 12.5702)
        
        // when
        let weather = try await weatherProvider.fetchWeather(coordinates: dummyCoords)
        
        // then
        // then
        
        // identification
        XCTAssertEqual(weather.date, Date(timeIntervalSince1970: 1653577971))
        XCTAssertEqual(weather.city, "Tårnby Kommune")
        XCTAssertEqual(weather.country, "DK")
        XCTAssertEqual(weather.weather, "Clouds")
        XCTAssertEqual(weather.icon, "03d")
        
        // invariable parameters
        XCTAssertEqual(weather.pressure, 1011)
        XCTAssertEqual(weather.humidity, 76)
        
        // parameters that vary by locale
        XCTAssertEqual(weather.visibility, 10)
        XCTAssertEqual(Int(weather.temperature * 100), 1425)
        XCTAssertEqual(Int(weather.minTemperature * 100), 1391)
        XCTAssertEqual(Int(weather.maxTemperature * 100), 1531)
        XCTAssertEqual(Int(weather.realFeel * 100), 1371)
        XCTAssertEqual(Int(weather.windSpeed * 100), 806)
        XCTAssertEqual(Int(weather.windDirection * 100), 224)
    }
    
    func testFetchForecast() async throws {
        // provided
        guard let path = self.bundle.url(forResource: "forecast", withExtension: "json") else {
            throw Error.decode
        }
        
        let data = try Data(contentsOf: path)
        let imperialLocale = LocaleService(locale: Locale(identifier: "en"))
        let network = NetworkMock(response: data)
        let weatherProvider = try WeatherProvider(networkSession: network, locale: imperialLocale)
        let dummyCoords = CLLocationCoordinate2D(latitude: 55.6178, longitude: 12.5702)
        
        // when
        let forecast = try await weatherProvider.fetchForecast(coordinates: dummyCoords)
        
        // then
        XCTAssertEqual(forecast[0].date, Date(timeIntervalSince1970: 1653577200))
        XCTAssertEqual(forecast[0].city, "Tårnby Kommune")
        XCTAssertEqual(forecast[0].country, "DK")
        XCTAssertEqual(forecast[0].weather, "Rain")
        XCTAssertEqual(forecast[0].icon, "10d")
        XCTAssertEqual(forecast[0].pressure, 1011)
        XCTAssertEqual(forecast[0].humidity, 75)
        XCTAssertEqual(Int(forecast[0].visibility * 100), 621)
        XCTAssertEqual(Int(forecast[0].temperature * 100), 5642)
        XCTAssertEqual(Int(forecast[0].minTemperature * 100), 5642)
        XCTAssertEqual(Int(forecast[0].maxTemperature * 100), 5808)
        XCTAssertEqual(Int(forecast[0].realFeel * 100), 5529)
        XCTAssertEqual(Int(forecast[0].windSpeed * 100), 2306)
        XCTAssertEqual(Int(forecast[0].windDirection * 100), 1031)
        
        XCTAssertEqual(forecast[1].date, Date(timeIntervalSince1970: 1653588000))
        XCTAssertEqual(forecast[1].city, "Tårnby Kommune")
        XCTAssertEqual(forecast[1].country, "DK")
        XCTAssertEqual(forecast[1].weather, "Clouds")
        XCTAssertEqual(forecast[1].icon, "04d")
        XCTAssertEqual(forecast[1].pressure, 1011)
        XCTAssertEqual(forecast[1].humidity, 72)
        XCTAssertEqual(Int(forecast[1].visibility * 100), 621)
        XCTAssertEqual(Int(forecast[1].temperature * 100), 5610)
        XCTAssertEqual(Int(forecast[1].minTemperature * 100), 5545)
        XCTAssertEqual(Int(forecast[1].maxTemperature * 100), 5610)
        XCTAssertEqual(Int(forecast[1].realFeel * 100), 5478)
        XCTAssertEqual(Int(forecast[1].windSpeed * 100), 2040)
        XCTAssertEqual(Int(forecast[1].windDirection * 100), 911)
        
        XCTAssertEqual(forecast[2].date, Date(timeIntervalSince1970: 1653598800))
        XCTAssertEqual(forecast[2].city, "Tårnby Kommune")
        XCTAssertEqual(forecast[2].country, "DK")
        XCTAssertEqual(forecast[2].weather, "Sun")
        XCTAssertEqual(forecast[2].icon, "03n")
        XCTAssertEqual(forecast[2].pressure, 1010)
        XCTAssertEqual(forecast[2].humidity, 74)
        XCTAssertEqual(Int(forecast[2].visibility * 100), 538)
        XCTAssertEqual(Int(forecast[2].temperature * 100), 5345)
        XCTAssertEqual(Int(forecast[2].minTemperature * 100), 5196)
        XCTAssertEqual(Int(forecast[2].maxTemperature * 100), 5345)
        XCTAssertEqual(Int(forecast[2].realFeel * 100), 5197)
        XCTAssertEqual(Int(forecast[2].windSpeed * 100), 1771)
        XCTAssertEqual(Int(forecast[2].windDirection * 100), 792)
    }
}
