//
//  WeatherTests.swift
//  SolTests
//
//  Created by Júlio César Flores on 27/05/22.
//

import XCTest
@testable import Sol

class WeatherData: XCTestCase {
    enum Error: Swift.Error {
        case decode
    }
    
    let bundle = Bundle(for: WeatherData.self)
    
    func testWeatherDataInMetricUnits() throws {
        // provided
        guard let path = self.bundle.url(forResource: "weather", withExtension: "json") else {
            throw Error.decode
        }
        
        let data = try Data(contentsOf: path)
        let decoder = JSONDecoder()
        let response = try decoder.decode(WeatherResponse.self, from: data)
        let locale = LocaleService(locale: Locale(identifier: "en-GB"))
        
        // when
        let weather = Weather(response: response, locale: locale)
        
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
        XCTAssertEqual(weather.temperature, 14)
        XCTAssertEqual(weather.minTemperature, 14)
        XCTAssertEqual(weather.maxTemperature, 15)
        XCTAssertEqual(weather.realFeel, 14)
        XCTAssertEqual(weather.windSpeed, 8)
        XCTAssertEqual(weather.windDirection, 2)
    }
    
    func testWeatherDataInImperialUnits() throws {
        // provided
        guard let path = self.bundle.url(forResource: "weather", withExtension: "json") else {
            throw Error.decode
        }
        
        let data = try Data(contentsOf: path)
        let decoder = JSONDecoder()
        let response = try decoder.decode(WeatherResponse.self, from: data)
        let locale = LocaleService(locale: Locale(identifier: "en"))
        
        // when
        let weather = Weather(response: response, locale: locale)
        
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
        XCTAssertEqual(weather.visibility, 6)
        XCTAssertEqual(weather.temperature, 58)
        XCTAssertEqual(weather.minTemperature, 57)
        XCTAssertEqual(weather.maxTemperature, 60)
        XCTAssertEqual(weather.realFeel, 57)
        XCTAssertEqual(weather.windSpeed, 5)
        XCTAssertEqual(weather.windDirection, 2)
    }
}
