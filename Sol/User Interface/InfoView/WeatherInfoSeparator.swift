//
//  WeatherInfoSeparator.swift
//  Sol
//
//  Created by Júlio César Flores on 02/06/22.
//

import SwiftUI

struct WeatherInfoSeparator: View {
    var body: some View {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Theme.Colour.primary.opacity(0.0), location: 0.0),
                Gradient.Stop(color: Theme.Colour.primary.opacity(0.5), location: 0.5),
                Gradient.Stop(color: Theme.Colour.primary.opacity(0.0), location: 1.0)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(maxWidth: .infinity, maxHeight: 1)
        .padding(0)
    }
}

struct WeatherInfoSeparator_Previews: PreviewProvider {
    static var previews: some View {
        WeatherInfoSeparator()
    }
}
