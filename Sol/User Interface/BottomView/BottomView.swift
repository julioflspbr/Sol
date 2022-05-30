//
//  BottomView.swift
//  Sol
//
//  Created by Júlio César Flores on 29/05/22.
//

import SwiftUI

struct BottomView: View {
    private static let initialHeight: CGFloat = 227

    private static let dragTreshold: CGFloat = 50

    @EnvironmentObject private var locale: LocaleService

    @State private var currentHeight = Self.initialHeight

    @State private var heightOffset = Self.initialHeight

    @State private var isExpanded = false

    @Binding private(set) var weatherIndex: Int

    let weatherData: [Weather]

    private var weather: Weather {
        self.weatherData[self.weatherIndex]
    }

    private let dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        VStack {
            handler

            header

            separator

            Group {
                item(label: locale["temperature"], value: "\(weather.temperature) \(weather.temperatureSymbol)")

                separator

                item(label: locale["real feel"], value: "\(weather.realFeel) \(weather.temperatureSymbol)")

                separator

                item(label: locale["min"], value: "\(weather.minTemperature) \(weather.temperatureSymbol)")

                separator

                item(label: locale["max"], value: "\(weather.maxTemperature) \(weather.temperatureSymbol)")

                separator
            }

            Group {
                item(label: locale["pressure"], value: "\(String(format: locale.isMetric ? "%.0f" : "%.2f", weather.pressure)) \(weather.pressureSymbol)")

                separator

                item(label: locale["visibility"], value: "\(weather.visibility) \(weather.distanceSymbol)")

                separator

                item(label: locale["humidity"], value: "\(weather.humidity) \(weather.humiditySymbol)")

                separator

                item(label: locale["wind direction"], value: "\(weather.windDirection)\(weather.directionSymbol)")

                separator

                item(label: locale["wind speed"], value: "\(weather.windSpeed) \(weather.speedSymbol)")

                separator
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

    private var header: some View {
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

            Text(dateFormater.string(from: weather.date))
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
        .padding()
    }

    private var handler: some View {
        Capsule()
            .foregroundColor(Theme.Colour.dragHandler)
            .frame(width: 40, height: 5, alignment: .center)
            .padding(.top, 10)
    }

    private func item(label: String, value: String) -> some View {
        HStack {
            Text(label + ":")
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text(value)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(-3)
    }

    private var separator: some View {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Theme.Colour.primary.opacity(0.0), location: 0.0),
                Gradient.Stop(color: Theme.Colour.primary.opacity(0.5), location: 0.5),
                Gradient.Stop(color: Theme.Colour.primary.opacity(0.0), location: 1.0),
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(maxWidth: .infinity, maxHeight: 1)
        .padding(0)
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

            BottomView(
                weatherIndex: .constant(0),
                weatherData: [Weather(
                    date: Date(),
                    city: "London",
                    country: "UK",
                    weather: "",
                    icon: "03d",
                    humidity: 0,
                    windDirection: 0,
                    visibility: 0,
                    temperature: 12,
                    minTemperature: 0,
                    maxTemperature: 0,
                    realFeel: 0,
                    pressure: 0,
                    windSpeed: 0,
                    pressureSymbol: "",
                    speedSymbol: "",
                    temperatureSymbol: "ºC",
                    distanceSymbol: ""
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
