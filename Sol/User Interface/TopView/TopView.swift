//
//  TopView.swift
//  Sol
//
//  Created by Júlio César Flores on 29/05/22.
//

import SwiftUI

struct TopView: View {
    @StateObject private var viewModel = TopViewModel()

    @EnvironmentObject private var weatherProvider: WeatherProvider

    @Binding private(set) var weatherIndex: Int

    let weatherData: [Weather]

    private var weather: Weather {
        self.weatherData[self.weatherIndex]
    }

    var body: some View {
        VStack {
            HStack {
                weatherIcon
                    .frame(width: 100, height: 100)
                    .padding(.horizontal)

                VStack(alignment: .leading) {
                    Text("\(weather.temperature) \(weather.temperatureSymbol)")
                        .font(.system(size: 30))
                        .foregroundColor(Theme.Colour.text)

                    Text("\(weather.city), \(weather.country)")
                        .font(.system(size: 15))
                        .foregroundColor(Theme.Colour.text)
                }
                .frame(minHeight: 100)

                Spacer()
            }
        }
        .background {
            LinearGradient(
                colors: [Theme.Colour.background, Theme.Colour.background.opacity(0.0)],
                startPoint: .center,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            self.viewModel.fetchWeatherIcon(provider: weatherProvider, weather: self.weather)
        }
        .onChange(of: weather) { (weather) in
            self.viewModel.fetchWeatherIcon(provider: weatherProvider, weather: weather)
        }
    }

    private var weatherIcon: some View {
        Group {
            if let icon = self.viewModel.weatherIcon {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
                    .scaleEffect(2)
            }
        }
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TopView(
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

            Spacer()
        }
        .background {
            Color.gray.ignoresSafeArea()
        }
    }
}
