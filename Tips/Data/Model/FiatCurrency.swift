//
//  Untitled.swift
//  TipGenius
//
//  Created by Wadealanchan on 14/7/2025.
//
import Foundation
import SwiftUI

struct FiatCurrency: Identifiable, Equatable {
    let id = UUID()
    let icon: String
    let name: String
    var amount: String
    var isFavorite: Bool = false
    let iconColor: Color

    static let `default` = FiatCurrency(
        icon: "eth_icon",
        name: "ETH",
        amount: "1",
        isFavorite: true,
        iconColor: .white
    )
}

let mockCurrency: [FiatCurrency] = [
    FiatCurrency(icon: "eth_icon", name: "ETH", amount: "1", isFavorite: true, iconColor: .white),
    FiatCurrency(icon: "bnb_icon", name: "BNB", amount: "0.02779175", iconColor: .yellow),
    FiatCurrency(icon: "btc_icon", name: "BTC", amount: "0", iconColor: .orange),
    FiatCurrency(icon: "usdt_icon", name: "USDT", amount: "0", iconColor: .green)
]
