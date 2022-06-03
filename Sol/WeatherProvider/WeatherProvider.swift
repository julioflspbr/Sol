//
//  WeatherProvider.swift
//  Sol
//
//  Created by Júlio César Flores on 27/05/22.
//

import MapKit
import SwiftUI
import AVFAudio
import Foundation

final class WeatherProvider: ObservableObject {
    private let weatherService: WeatherService
    private let locale: LocaleService

    init(networkSession: NetworkSession = URLSession.shared, locale: LocaleService = LocaleService()) throws {
        self.weatherService = try WeatherService(networkSession: networkSession, locale: locale)
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

    func generateAudioDescription(for weather: Weather) -> String {
        var calendar = Calendar.current
        calendar.timeZone = self.locale.timeZone
        let dateComponents = calendar.dateComponents([.day, .hour], from: weather.date)

        var description = String()

        // identification
        description += "\(locale["weather for"]) \(weather.city),"

        // time
        if  let day = dateComponents.day,
            let hour = dateComponents.hour,
            let dayDescription = locale.numberFormatter.string(from: NSNumber(value: day)),
            let hourDescription = locale.numberFormatter.string(from: NSNumber(value: hour)) {
            description += "\(locale["day"]) \(dayDescription), \(locale["hour"]) \(hourDescription),"
        }

        // short weather description
        description += "\(weather.description),"

        // temperature
        if let temperature = locale.numberFormatter.string(from: NSNumber(value: weather.temperature)) {
            let unit = locale.measurementFormatter.string(from: locale.unitSystem.temperature)
            description += "\(locale["temperature"]) \(temperature) \(unit),"
        }

        // real feel
        if let realFeel = locale.numberFormatter.string(from: NSNumber(value: weather.realFeel)) {
            let unit = locale.measurementFormatter.string(from: locale.unitSystem.temperature)
            description += "\(locale["real feel"]) \(realFeel) \(unit),"
        }

        // min temp
        if let minTemperature = locale.numberFormatter.string(from: NSNumber(value: weather.minTemperature)) {
            let unit = locale.measurementFormatter.string(from: locale.unitSystem.temperature)
            description += "\(locale["minimum temperature"]) \(minTemperature) \(unit),"
        }

        // max temp
        if let maxTemperature = locale.numberFormatter.string(from: NSNumber(value: weather.maxTemperature)) {
            let unit = locale.measurementFormatter.string(from: locale.unitSystem.temperature)
            description += "\(locale["maximum temperature"]) \(maxTemperature) \(unit),"
        }

        // pressure
        if let pressure = locale.numberFormatter.string(from: NSNumber(value: weather.pressure)) {
            let unit = locale.measurementFormatter.string(from: locale.unitSystem.pressure)
            description += "\(locale["pressure"]) \(pressure) \(unit),"
        }

        // visibility
        if let visibility = locale.numberFormatter.string(from: NSNumber(value: weather.visibility)) {
            let unit = locale.measurementFormatter.string(from: locale.unitSystem.distance)
            description += "\(locale["visibility"]) \(visibility) \(unit),"
        }

        // humidity
        if let humidity = locale.numberFormatter.string(from: NSNumber(value: weather.humidity)) {
            description += "\(locale["humidity"]) \(humidity) \(locale["percent"]),"
        }

        // wind direction
        if let windDirection = locale.numberFormatter.string(from: NSNumber(value: weather.windDirection)) {
            description += "\(locale["wind direction"]) \(windDirection) \(locale["degrees"]),"
        }

        // wind speed
        if let windSpeed = locale.numberFormatter.string(from: NSNumber(value: weather.windSpeed)) {
            let unit = locale.measurementFormatter.string(from: locale.unitSystem.speed)
            description += "\(locale["wind speed"]) \(windSpeed) \(unit)."
        }

        return description
    }
}
