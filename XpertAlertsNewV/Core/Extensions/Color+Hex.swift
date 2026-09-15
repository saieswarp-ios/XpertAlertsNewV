//
//  Color+Hex.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 10/09/26.
//


// custom colorsssssss
import SwiftUI

extension Color {

    init(hex: String) {

        let scanner = Scanner(
            string: hex.trimmingCharacters(
                in: CharacterSet.alphanumerics.inverted
            )
        )

        var hexNumber: UInt64 = 0

        scanner.scanHexInt64(&hexNumber)

        let r = Double((hexNumber & 0xff0000) >> 16) / 255
        let g = Double((hexNumber & 0x00ff00) >> 8) / 255
        let b = Double(hexNumber & 0x0000ff) / 255

        self.init(red: r, green: g, blue: b)
    }

    static let themeOrange = Color(hex: "#EE6C20")
    static let themeGreen = Color(hex: "#008040")
    static let themePurple = Color(hex: "#5C2D91")

    static let themeRed = Color(hex: "#FF0000")
    static let themeBlue = Color(hex: "#007AFF")
}
