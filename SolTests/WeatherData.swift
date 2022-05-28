//
//  WeatherProvider.swift
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
        XCTAssertEqual(Int(weather.temperature * 100), 1425)
        XCTAssertEqual(Int(weather.minTemperature * 100), 1391)
        XCTAssertEqual(Int(weather.maxTemperature * 100), 1531)
        XCTAssertEqual(Int(weather.realFeel * 100), 1371)
        XCTAssertEqual(Int(weather.windSpeed * 100), 806)
        XCTAssertEqual(Int(weather.windDirection * 100), 224)
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
        XCTAssertEqual(Int(weather.visibility * 100), 621)
        XCTAssertEqual(Int(weather.temperature * 100), 5764)
        XCTAssertEqual(Int(weather.minTemperature * 100), 5703)
        XCTAssertEqual(Int(weather.maxTemperature * 100), 5955)
        XCTAssertEqual(Int(weather.realFeel * 100), 5667)
        XCTAssertEqual(Int(weather.windSpeed * 100), 501)
        XCTAssertEqual(Int(weather.windDirection * 100), 224)
    }
}
