//
//  WeatherInfoItem.swift
//  Sol
//
//  Created by Júlio César Flores on 02/06/22.
//

import SwiftUI

struct WeatherInfoItem: View {
    var label: String

    var value: String

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(label + ":")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text(value)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 7)

            WeatherInfoSeparator()
        }
    }
}

struct WeatherInfoItem_Previews: PreviewProvider {
    static var previews: some View {
        WeatherInfoItem(label: "temperature", value: "15 ºC")
    }
}
