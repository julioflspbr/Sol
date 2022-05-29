//
//  MapView.swift
//  Sol
//
//  Created by Júlio César Flores on 28/05/22.
//

import MapKit
import SwiftUI

struct MapView: View {
    @Binding private(set) var location: MKCoordinateRegion
    
    var body: some View {
        Map(coordinateRegion: $location)
            .ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(location: Binding(get: { MainViewModel.defaultRegion }, set: { _ in }))
    }
}
