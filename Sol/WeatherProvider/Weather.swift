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
    let humidity: Double
    
    let windDirection: Double
    
    // MARK: - Units that vary according to locale
    let visibility: Double
    
    let temperature: Double
    
    let minTemperature: Double
    
    let maxTemperature: Double
    
    let realFeel: Double
    
    let pressure: Double
    
    let windSpeed: Double
    
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
        self.humidity = response.humidity
        self.windDirection = response.windSpeed
        
        let baseVisibility = LocaleService.weatherStandards.distance.converter.baseUnitValue(fromValue: response.visibility)
        let baseTemperature = LocaleService.weatherStandards.temperature.converter.baseUnitValue(fromValue: response.temperature)
        let baseMinTemperature = LocaleService.weatherStandards.temperature.converter.baseUnitValue(fromValue: response.minTemperature)
        let baseMaxTemperature = LocaleService.weatherStandards.temperature.converter.baseUnitValue(fromValue: response.maxTemperature)
        let baseRealFeel = LocaleService.weatherStandards.temperature.converter.baseUnitValue(fromValue: response.realFeel)
        let basePressure = LocaleService.weatherStandards.pressure.converter.baseUnitValue(fromValue: response.pressure)
        let baseWindSpeed = LocaleService.weatherStandards.speed.converter.baseUnitValue(fromValue: response.windSpeed)
        
        self.visibility = locale.unitSystem.distance.converter.value(fromBaseUnitValue: baseVisibility)
        self.temperature = locale.unitSystem.temperature.converter.value(fromBaseUnitValue: baseTemperature)
        self.minTemperature = locale.unitSystem.temperature.converter.value(fromBaseUnitValue: baseMinTemperature)
        self.maxTemperature = locale.unitSystem.temperature.converter.value(fromBaseUnitValue: baseMaxTemperature)
        self.realFeel = locale.unitSystem.temperature.converter.value(fromBaseUnitValue: baseRealFeel)
        self.pressure = locale.unitSystem.pressure.converter.value(fromBaseUnitValue: basePressure)
        self.windSpeed = locale.unitSystem.speed.converter.value(fromBaseUnitValue: baseWindSpeed)
        
        self.pressureSymbol = locale.unitSystem.pressure.symbol
        self.speedSymbol = locale.unitSystem.speed.symbol
        self.temperatureSymbol = locale.unitSystem.temperature.symbol
    }
}
