//
//  ContentView.swift
//  Sol
//
//  Created by Júlio César Flores on 26/05/22.
//

import MapKit
import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        Map(coordinateRegion: $viewModel.location)
            .ignoresSafeArea()
            .onAppear(perform: self.viewModel.requestLocation)
            .onChange(of: viewModel.location) { (newLocation) in
                print("Location changed: \(newLocation)")
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
