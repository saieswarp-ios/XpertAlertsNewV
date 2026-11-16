//
//  Font+Extension.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 11/11/26.
//

import SwiftUI

// 1. Custom ViewModifier to apply the font globally
struct GlobalFontModifier: ViewModifier {
    var size: CGFloat = 16
    
    func body(content: Content) -> some View {
        content
            // Replace with your exact registered PostScript name
            .font(.custom("PlaywriteUSModern-Regular", size: size))
    }
}

// 2. View Extension for easy access
extension View {
    func useGlobalFont(size: CGFloat = 16) -> some View {
        self.modifier(GlobalFontModifier(size: size))
    }
}
