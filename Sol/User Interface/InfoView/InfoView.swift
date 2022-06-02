//
//  InfoView.swift
//  Sol
//
//  Created by Júlio César Flores on 29/05/22.
//

import SwiftUI

struct InfoView: View {
    private static let initialHeight: CGFloat = 227

    private static let dragTreshold: CGFloat = 50

    private let viewModel = InfoViewModel()

    @EnvironmentObject private var locale: LocaleService

    @EnvironmentObject private var weatherProvider: WeatherProvider

    @State private var currentHeight = Self.initialHeight

    @State private var heightOffset = Self.initialHeight

    @State private var isExpanded = false

    @Binding private(set) var weatherIndex: Int

    let weatherData: [Weather]

    private var weather: Weather {
        self.weatherData[self.weatherIndex]
    }

    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Theme.Colour.secondary)
                .frame(width: 40, height: 5, alignment: .center)
                .padding(10)

            AudioDescriptionButton {
                self.viewModel.handleAudioDescription(for: self.weather, weatherProvider: self.weatherProvider, locale: self.locale)
            }

            WeatherInfoHeader(weatherData: weatherData, weatherIndex: $weatherIndex).padding()

            WeatherInfoSeparator()

            Group {
                WeatherInfoItem(label: locale["temperature"], value: "\(weather.temperature) \(weather.temperatureSymbol)")

                WeatherInfoItem(label: locale["real feel"], value: "\(weather.realFeel) \(weather.temperatureSymbol)")

                WeatherInfoItem(label: locale["min"], value: "\(weather.minTemperature) \(weather.temperatureSymbol)")

                WeatherInfoItem(label: locale["max"], value: "\(weather.maxTemperature) \(weather.temperatureSymbol)")

                WeatherInfoItem(label: locale["pressure"], value: "\(String(format: locale.isMetric ? "%.0f" : "%.2f", weather.pressure)) \(weather.pressureSymbol)")

                WeatherInfoItem(label: locale["visibility"], value: "\(weather.visibility) \(weather.distanceSymbol)")

                WeatherInfoItem(label: locale["humidity"], value: "\(weather.humidity) \(weather.humiditySymbol)")

                WeatherInfoItem(label: locale["wind direction"], value: "\(weather.windDirection)\(weather.directionSymbol)")

                WeatherInfoItem(label: locale["wind speed"], value: "\(weather.windSpeed) \(weather.speedSymbol)")
            }
        }
        .background{
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Theme.Colour.background)
                .shadow(radius: 5)
                .ignoresSafeArea()
        }
        .offset(x: 0.0, y: heightOffset)
        .animation(.easeOut(duration: 0.1), value: self.isExpanded)
        .gesture(
            DragGesture()
                .onChanged(self.fenceOffset(drag:))
                .onEnded(self.finishDrag(drag:))
        )
    }

    private func fenceOffset(drag: DragGesture.Value) {
        self.heightOffset = max(self.currentHeight + drag.translation.height, 0)
        self.heightOffset = min(self.heightOffset, Self.initialHeight)
    }

    private func finishDrag(drag: DragGesture.Value) {
        let isWithinBoundaries = (self.currentHeight + drag.translation.height >= 0) && (self.currentHeight + drag.translation.height <= Self.initialHeight)
        let isWideEnough = abs(drag.translation.height) > Self.dragTreshold

        guard isWithinBoundaries else {
            return
        }

        if isWideEnough {
            self.isExpanded = !self.isExpanded
        }

        if self.isExpanded {
            self.currentHeight = 0
            self.heightOffset = 0
        } else {
            self.currentHeight = Self.initialHeight
            self.heightOffset = Self.initialHeight
        }
    }
}

struct BottomView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()

            InfoView(
                weatherIndex: .constant(0),
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
                )]
            )
            .environmentObject(try! WeatherProvider())
            .environmentObject(LocaleService())
        }
        .background {
            Color.gray.ignoresSafeArea()
        }
    }
}
