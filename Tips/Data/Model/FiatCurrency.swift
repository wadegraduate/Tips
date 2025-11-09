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

    static let `default` = FiatCurrency(
        icon: "usd_icon",
        name: "USD",
        amount: "1",
        isFavorite: true,
    )
}

let mockCurrency: [FiatCurrency] = [
    FiatCurrency(icon: "eth_icon", name: "ETH", amount: "1", isFavorite: true),
    FiatCurrency(icon: "bnb_icon", name: "BNB", amount: "0.02779175"),
    FiatCurrency(icon: "btc_icon", name: "BTC", amount: "0"),
    FiatCurrency(icon: "usdt_icon", name: "USDT", amount: "0")
]
