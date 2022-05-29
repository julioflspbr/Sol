//
//  Weather.swift
//  Sol
//
//  Created by Júlio César Flores on 27/05/22.
//

import Foundation

struct Weather {
    // MARK: - Place & Weather info
    
    let date: Date
    
    let city: String
    
    let country: String
    
    let weather: String
    
    let icon: String
    
    // MARK: - Units that are invariable based on locale    
    let humidity: Int
    
    let windDirection: Int
    
    // MARK: - Units that vary according to locale
    let visibility: Int
    
    let temperature: Int
    
    let minTemperature: Int
    
    let maxTemperature: Int
    
    let realFeel: Int
    
    let pressure: Double
    
    let windSpeed: Int
    
    // MARK: - Unit Symbols
    let humiditySymbol: String = "%"
    
    let directionSymbol: String = "º"
    
    let pressureSymbol: String
    
    let speedSymbol: String
    
    let temperatureSymbol: String
    
    // MARK: - Initialiser
    init(response: WeatherResponse, locale: LocaleService) {
        self.date = response.date
        self.city = response.city
        self.country = response.country
        self.weather = response.weather
        self.icon = response.icon
        self.humidity = Int(response.humidity)
        self.windDirection = Int(response.windSpeed)
        
        let baseVisibility = LocaleService.weatherStandards.distance.converter.baseUnitValue(fromValue: response.visibility)
        let baseTemperature = LocaleService.weatherStandards.temperature.converter.baseUnitValue(fromValue: response.temperature)
        let baseMinTemperature = LocaleService.weatherStandards.temperature.converter.baseUnitValue(fromValue: response.minTemperature)
        let baseMaxTemperature = LocaleService.weatherStandards.temperature.converter.baseUnitValue(fromValue: response.maxTemperature)
        let baseRealFeel = LocaleService.weatherStandards.temperature.converter.baseUnitValue(fromValue: response.realFeel)
        let basePressure = LocaleService.weatherStandards.pressure.converter.baseUnitValue(fromValue: response.pressure)
        let baseWindSpeed = LocaleService.weatherStandards.speed.converter.baseUnitValue(fromValue: response.windSpeed)
        
        self.visibility = Int(round(locale.unitSystem.distance.converter.value(fromBaseUnitValue: baseVisibility)))
        self.temperature = Int(round(locale.unitSystem.temperature.converter.value(fromBaseUnitValue: baseTemperature)))
        self.minTemperature = Int(round(locale.unitSystem.temperature.converter.value(fromBaseUnitValue: baseMinTemperature)))
        self.maxTemperature = Int(round(locale.unitSystem.temperature.converter.value(fromBaseUnitValue: baseMaxTemperature)))
        self.realFeel = Int(round(locale.unitSystem.temperature.converter.value(fromBaseUnitValue: baseRealFeel)))
        self.pressure = locale.unitSystem.pressure.converter.value(fromBaseUnitValue: basePressure)
        self.windSpeed = Int(round(locale.unitSystem.speed.converter.value(fromBaseUnitValue: baseWindSpeed)))
        
        self.pressureSymbol = locale.unitSystem.pressure.symbol
        self.speedSymbol = locale.unitSystem.speed.symbol
        self.temperatureSymbol = locale.unitSystem.temperature.symbol
    }


    /// Initialiser used for preview and testing only
    init(
        date: Date,
        city: String,
        country: String,
        weather: String,
        icon: String,
        humidity: Int,
        windDirection: Int,
        visibility: Int,
        temperature: Int,
        minTemperature: Int,
        maxTemperature: Int,
        realFeel: Int,
        pressure: Double,
        windSpeed: Int,
        pressureSymbol: String,
        speedSymbol: String,
        temperatureSymbol: String
    ) {
        self.date = date
        self.city = city
        self.country = country
        self.weather = weather
        self.icon = icon
        self.humidity = humidity
        self.windDirection = windDirection
        self.visibility = visibility
        self.temperature = temperature
        self.minTemperature = minTemperature
        self.maxTemperature = maxTemperature
        self.realFeel = realFeel
        self.pressure = pressure
        self.windSpeed = windSpeed
        self.pressureSymbol = pressureSymbol
        self.speedSymbol = speedSymbol
        self.temperatureSymbol = temperatureSymbol
    }
}
