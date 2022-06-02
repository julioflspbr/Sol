//
//  WeatherInfoHeader.swift
//  Sol
//
//  Created by Júlio César Flores on 02/06/22.
//

import SwiftUI

struct WeatherInfoHeader: View {
    let weatherData: [Weather]

    @Binding private(set) var weatherIndex: Int

    private let dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        HStack {
            Button(
                action: {
                    if self.weatherIndex > 0 {
                        self.weatherIndex -= 1
                    }
                },
                label: {
                    Image(systemName: "chevron.left")
                }
            )
            .foregroundColor(weatherIndex <= 0 ? Theme.Colour.disabled : Theme.Colour.primary)
            .disabled(weatherIndex <= 0)

            Spacer()

            Text(dateFormater.string(from: weatherData[weatherIndex].date))
                .fontWeight(.black)
                .foregroundColor(Theme.Colour.text)

            Spacer()

            Button(
                action: {
                    if self.weatherIndex < self.weatherData.count - 1 {
                        self.weatherIndex += 1
                    }
                },
                label: {
                    Image(systemName: "chevron.right")
                }
            )
            .foregroundColor(weatherIndex >= weatherData.count - 1 ? Theme.Colour.disabled : Theme.Colour.primary)
            .disabled(weatherIndex >= weatherData.count - 1)
        }
    }
}

struct WeatherInfoHeader_Previews: PreviewProvider {
    static var previews: some View {
        WeatherInfoHeader(
            weatherData: [Weather(
                date: Date(),
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
            )],
            weatherIndex: .constant(0)
        )
    }
}
