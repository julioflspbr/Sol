//
//  AudioDescriptionButton.swift
//  Sol
//
//  Created by Júlio César Flores on 02/06/22.
//

import SwiftUI

struct AudioDescriptionButton: View {
    var action: (() -> Void)

    var body: some View {
        Button(
            action: action,
            label: {
                Image(systemName: "speaker.wave.3.fill")
                    .renderingMode(.template)
                    .foregroundColor(Theme.Colour.secondary)
            }
        )
    }
}

struct AudioDescriptionButton_Previews: PreviewProvider {
    static var previews: some View {
        AudioDescriptionButton(action: {})
    }
}
