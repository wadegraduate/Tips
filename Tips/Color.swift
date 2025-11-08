//
//  Color.swift
//  Tips
//
//  Created by Wadealanchan on 21/2/2024.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let background = Color("background")
    let secondaryBackground = Color("secondaryBackground")
    let secondaryBlue = Color("secondaryBlue")
    let sheetColor1 = Color("SheetColor1")
    let standardText = Color("standardText")
    let primaryGray = Color(#colorLiteral(red: 0.6980392157, green: 0.7176470588, blue: 0.7607843137, alpha: 1))
    let secondaryGray = Color(#colorLiteral(red: 0.5764705882, green: 0.5882352941, blue: 0.6392156863, alpha: 1))
    let tabbarColor = Color("tabbarColor")
    let sheetBackground = Color("sheetBackground")
    let red = Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
    let iconTintColor = Color("iconTintColor")
    let cardViewBackground = Color("CardViewBackground")
    let secondaryCardViewBackground = Color("secondaryCardViewBackground")
    
}
