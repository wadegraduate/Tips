//
//  Untitled.swift
//  TipGenius
//
//  Created by Wadealanchan on 14/7/2025.
//
import Foundation
import SwiftUI

struct CryptoCurrency: Identifiable, Equatable {
    let id = UUID()
    let icon: String
    let name: String
    let network: String
    var address: String? = nil
    var amount: String? = nil
    var isFavorite: Bool = false
    let iconColor: Color

    static let `default` = CryptoCurrency(
        icon: "eth_icon",
        name: "ETH",
        network: "BEP20",
        address: "0x2170...f933f8",
        amount: "1",
        isFavorite: true,
        iconColor: .white
    )
}
