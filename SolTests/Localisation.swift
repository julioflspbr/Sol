//
//  Localisation.swift
//  SolTests
//
//  Created by Júlio César Flores on 27/05/22.
//

import XCTest
@testable import Sol

class Localisation: XCTestCase {
    func testFetchCopy() {
        // provided
        let locale = LocaleService(locale: Locale(identifier: "en"))
        
        // when
        let copy = locale["test string"]
        
        // then
        XCTAssertEqual(copy, "Revenge is never plenty, it kills the soul and poisons it - Don Ramón")
    }
    
    func testLocalisedCopy() {
        // provided
        let englishLocale = LocaleService(locale: Locale(identifier: "en"))
        let spanishLocale = LocaleService(locale: Locale(identifier: "es"))
        let hebrewLocale = LocaleService(locale: Locale(identifier: "he"))
        
        // when
        let englishCopy = englishLocale["test string"]
        let spanishCopy = spanishLocale["test string"]
        let hebrewCopy = hebrewLocale["test string"]
        
        // then
        XCTAssertEqual(englishCopy, "Revenge is never plenty, it kills the soul and poisons it - Don Ramón")
        XCTAssertEqual(spanishCopy, "La venganza nunca es plena, mata el alma y la envenena - Don Ramón")
        XCTAssertEqual(hebrewCopy, "הנקמה לעולם אינה מלאה, היא הורגת את הנשמה ומרעילה אותה - דון רמון")
    }
    
    func testUnitSystems() {
        // provided
        let metricLocale = LocaleService(locale: Locale(identifier: "en-GB"))
        let imperialLocale = LocaleService(locale: Locale(identifier: "en"))
        
        // when
        let metricSystem = metricLocale.unitSystem
        let imperialSystem = imperialLocale.unitSystem
        
        // then
        XCTAssertEqual(metricSystem.temperature, .celsius)
        XCTAssertEqual(metricSystem.pressure, .hectopascals)
        XCTAssertEqual(metricSystem.distance, .meters)
        XCTAssertEqual(metricSystem.speed, .kilometersPerHour)
        
        XCTAssertEqual(imperialSystem.temperature, .fahrenheit)
        XCTAssertEqual(imperialSystem.pressure, .millibars)
        XCTAssertEqual(imperialSystem.distance, .miles)
        XCTAssertEqual(imperialSystem.speed, .milesPerHour)
    }
}
