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
        Map(coordinateRegion: $viewModel.location)
            .ignoresSafeArea()
            .onAppear(perform: viewModel.requestLocation)
            .onChange(of: viewModel.location) { (newLocation) in
                self.viewModel.requestWeather(for: newLocation, weatherProvider: self.weatherProvider)
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
