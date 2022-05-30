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

    @State private var selectedIndex: Int = 0

    var body: some View {
        GeometryReader { (proxy) in
            ZStack {
                Map(coordinateRegion: $viewModel.location)
                    .ignoresSafeArea()
                    .onAppear(perform: viewModel.requestLocation)
                    .onChange(of: viewModel.location) { (newLocation) in
                        self.viewModel.requestWeather(for: newLocation, weatherProvider: self.weatherProvider)
                    }

                VStack {
                    if viewModel.weatherData.count > 0 {
                        TopView(weatherIndex: $selectedIndex, weatherData: viewModel.weatherData)
                            .padding(.top, proxy.safeAreaInsets.top)
                    }

                    Spacer()

                    if viewModel.weatherData.count > 0 {
                        BottomView(weatherIndex: $selectedIndex, weatherData: viewModel.weatherData)
                    }
                }
            }
            .overlay {
                ZStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(3.0)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Theme.Colour.background)
                            .transition(.opacity)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Group {
                    if viewModel.weatherData.count > 0 {
                        Theme.Colour.background.frame(height: proxy.safeAreaInsets.bottom)
                    }
                }
            }
            .ignoresSafeArea()
        }
        .onChange(of: viewModel.weatherData) { _ in
            self.selectedIndex = 0
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(try! WeatherProvider())
    }
}
