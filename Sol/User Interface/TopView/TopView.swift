//
//  TopView.swift
//  Sol
//
//  Created by Júlio César Flores on 29/05/22.
//

import SwiftUI

struct TopView: View {
    let temperature: String
    let location: String
    let weatherIcon: Image

    var body: some View {
        VStack {
            VStack {
                HStack {
                    weatherIcon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 100)
                        .padding(.horizontal)

                    VStack(alignment: .leading) {
                        Text(temperature)
                            .font(.system(size: 30))
                            .foregroundColor(Theme.Colour.text)

                        Text(location)
                            .font(.system(size: 15))
                            .foregroundColor(Theme.Colour.text)
                    }
                    .frame(minHeight: 100)

                    Spacer()
                }

                Capsule()
                    .foregroundColor(Theme.Colour.dragHandler)
                    .frame(width: 40, height: 5, alignment: .center)
                    .padding(.bottom, 10)
            }
            .background {
                Theme.Colour.background
                    .blur(radius: 7)
                    .ignoresSafeArea()
            }


            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray)
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView(
            temperature: "10 ºC",
            location: "London, UK",
            weatherIcon: Image(systemName: "square")
        )
    }
}
