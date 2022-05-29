//
//  ContentView.swift
//  Sol
//
//  Created by Júlio César Flores on 26/05/22.
//

import MapKit
import SwiftUI

struct MainView: View {
    @EnvironmentObject private var weatherProvider: WeatherProvider

    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.location)
                .ignoresSafeArea()
                .onAppear(perform: viewModel.requestLocation)
                .onChange(of: viewModel.location) { (newLocation) in
                    self.viewModel.requestWeather(for: newLocation, weatherProvider: self.weatherProvider)
                }

            VStack {
                if let currentWeather = viewModel.weatherData.first {
                    TopView(weather: currentWeather)
                }

                Spacer()

                if let currentWeather = viewModel.weatherData.first {
                    BottomView(weather: currentWeather)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(try! WeatherProvider())
    }
}
