//
//  BottomView.swift
//  Sol
//
//  Created by Júlio César Flores on 29/05/22.
//

import SwiftUI

struct BottomView: View {
    @EnvironmentObject private var locale: LocaleService

    let weather: Weather

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
            }
        }
        .background{
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Theme.Colour.background)
                .shadow(radius: 5)
                .ignoresSafeArea()
        }
    }

    private var header: some View {
        HStack {
            Button(
                action: {

                },
                label: {
                    Image(systemName: "chevron.left")
                }
            )
            .foregroundColor(Theme.Colour.primary)

            Spacer()

            Text(dateFormater.string(from: weather.date))
                .fontWeight(.black)
                .foregroundColor(Theme.Colour.text)

            Spacer()

            Button(
                action: {

                },
                label: {
                    Image(systemName: "chevron.right")
                }
            )
            .foregroundColor(Theme.Colour.primary)
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
}

struct BottomView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()

            BottomView(weather: Weather(
                date: .now,
                city: "London",
                country: "UK",
                weather: "",
                icon: "03d",
                humidity: 78,
                windDirection: 180,
                visibility: 7,
                temperature: 12,
                minTemperature: 5,
                maxTemperature: 20,
                realFeel: 10,
                pressure: 1013,
                windSpeed: 13,
                pressureSymbol: "hPa",
                speedSymbol: "km/h",
                temperatureSymbol: "ºC",
                distanceSymbol: "km"
            ))
            .environmentObject(try! WeatherProvider())
            .environmentObject(LocaleService())
        }
        .background {
            Color.gray.ignoresSafeArea()
        }
    }
}
