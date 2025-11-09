//
//  CurrencyRatesResponse.swift
//  TipGenius
//
//  Created by Wadealanchan on 8/11/2025.
//

import Foundation

/// Response model for currency rates API
struct CurrencyRatesResponse: Decodable {
    let disclaimer: String
    let license: String
    let timestamp: Int
    let base: String
    let rates: [String: Double]
}

