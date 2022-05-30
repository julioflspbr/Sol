//
//  Colour.swift
//  Sol
//
//  Created by Júlio César Flores on 29/05/22.
//

import SwiftUI
import Foundation

struct Theme {
    struct Colour {
        static var background: Color {
            Color("background")
        }

        static var text: Color {
            Color("primary")
        }

        static var primary: Color {
            Color("primary")
        }

        static var disabled: Color {
            Color("disabled")
        }

        static var dragHandler: Color {
            Color("dragHandler")
        }
    }

    struct Image {
        static var weatherFallback: SwiftUI.Image {
            SwiftUI.Image(systemName: "exclamationmark.icloud")
        }
    }
}
