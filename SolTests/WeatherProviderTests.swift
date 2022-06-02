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
        XCTAssertEqual(weather.temperature, 14)
        XCTAssertEqual(weather.minTemperature, 14)
        XCTAssertEqual(weather.maxTemperature, 15)
        XCTAssertEqual(weather.realFeel, 14)
        XCTAssertEqual(weather.windSpeed, 8)
        XCTAssertEqual(weather.windDirection, 2)
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
        XCTAssertEqual(forecast[0].humidity, 75)
        XCTAssertEqual(forecast[0].visibility, 6)
        XCTAssertEqual(forecast[0].temperature, 56)
        XCTAssertEqual(forecast[0].minTemperature, 56)
        XCTAssertEqual(forecast[0].maxTemperature, 58)
        XCTAssertEqual(forecast[0].realFeel, 55)
        XCTAssertEqual(forecast[0].windSpeed, 23)
        XCTAssertEqual(forecast[0].windDirection, 10)
        XCTAssertEqual(Int(forecast[0].pressure * 100), 2985)
        
        XCTAssertEqual(forecast[1].date, Date(timeIntervalSince1970: 1653588000))
        XCTAssertEqual(forecast[1].city, "Tårnby Kommune")
        XCTAssertEqual(forecast[1].country, "DK")
        XCTAssertEqual(forecast[1].weather, "Clouds")
        XCTAssertEqual(forecast[1].icon, "04d")
        XCTAssertEqual(forecast[1].humidity, 72)
        XCTAssertEqual(forecast[1].visibility, 6)
        XCTAssertEqual(forecast[1].temperature, 56)
        XCTAssertEqual(forecast[1].minTemperature, 55)
        XCTAssertEqual(forecast[1].maxTemperature, 56)
        XCTAssertEqual(forecast[1].realFeel, 55)
        XCTAssertEqual(forecast[1].windSpeed, 20)
        XCTAssertEqual(forecast[1].windDirection, 9)
        XCTAssertEqual(Int(forecast[1].pressure * 100), 2985)
        
        XCTAssertEqual(forecast[2].date, Date(timeIntervalSince1970: 1653598800))
        XCTAssertEqual(forecast[2].city, "Tårnby Kommune")
        XCTAssertEqual(forecast[2].country, "DK")
        XCTAssertEqual(forecast[2].weather, "Sun")
        XCTAssertEqual(forecast[2].icon, "03n")
        XCTAssertEqual(forecast[2].humidity, 74)
        XCTAssertEqual(forecast[2].visibility, 5)
        XCTAssertEqual(forecast[2].temperature, 53)
        XCTAssertEqual(forecast[2].minTemperature, 52)
        XCTAssertEqual(forecast[2].maxTemperature, 53)
        XCTAssertEqual(forecast[2].realFeel, 52)
        XCTAssertEqual(forecast[2].windSpeed, 18)
        XCTAssertEqual(forecast[2].windDirection, 7)
        XCTAssertEqual(Int(forecast[2].pressure * 100), 2982)
    }

    func testEnglishAudioDescriptionGeneration() throws {
        // provided
        let weather = Weather(
            date: Date(timeIntervalSince1970: 1653577971),
            city: "London",
            country: "UK",
            weather: "",
            description: "scattered clouds",
            icon: "03d",
            humidity: 76,
            windDirection: 2,
            visibility: 10,
            temperature: 14,
            minTemperature: 14,
            maxTemperature: 15,
            realFeel: 14,
            pressure: 1011,
            windSpeed: 8,
            pressureSymbol: "hPa",
            speedSymbol: "km/h",
            temperatureSymbol: "ºC",
            distanceSymbol: "km"
        )

        let network = NetworkMock(response: Data())
        let locale = LocaleService(locale: Locale(identifier: "en-GB"), timeZone: TimeZone(secondsFromGMT: 0)!)
        let weatherProvider = try WeatherProvider(networkSession: network, locale: locale)

        // when
        let audioDescription = weatherProvider.generateAudioDescription(for: weather)

        // then
        XCTAssertEqual(audioDescription.lowercased(), "weather forecast for london,day twenty-six, hour fifteen,scattered clouds,temperature fourteen degrees celsius,real feel fourteen degrees celsius,minimum temperature fourteen degrees celsius,maximum temperature fifteen degrees celsius,pressure one thousand eleven hectopascals,visibility ten kilometres,humidity seventy-six percent,wind direction two degrees,wind speed eight kilometres per hour.")
    }

    func testPortugueseAudioDescriptionGeneration() throws {
        let weather = Weather(
            date: Date(timeIntervalSince1970: 1653577971),
            city: "Londres",
            country: "UK",
            weather: "",
            description: "nuvens esparsas",
            icon: "03d",
            humidity: 76,
            windDirection: 2,
            visibility: 10,
            temperature: 14,
            minTemperature: 14,
            maxTemperature: 15,
            realFeel: 14,
            pressure: 1011,
            windSpeed: 8,
            pressureSymbol: "hPa",
            speedSymbol: "km/h",
            temperatureSymbol: "ºC",
            distanceSymbol: "km"
        )

        let network = NetworkMock(response: Data())
        let locale = LocaleService(locale: Locale(identifier: "pt-BR"), timeZone: TimeZone(secondsFromGMT: 0)!)
        let weatherProvider = try WeatherProvider(networkSession: network, locale: locale)

        // when
        let audioDescription = weatherProvider.generateAudioDescription(for: weather)

        // then
        XCTAssertEqual(audioDescription.lowercased(), "previsão do tempo para londres,dia vinte e seis, hora quinze,nuvens esparsas,temperatura catorze graus celsius,sensação térmica catorze graus celsius,temperatura mínima catorze graus celsius,temperatura máxima quinze graus celsius,pressão mil e onze hectopascais,visibilidade dez quilômetros,umidade setenta e seis por cento,direção do vento dois graus,velocidade do vento oito quilômetros por hora.")
    }
}
