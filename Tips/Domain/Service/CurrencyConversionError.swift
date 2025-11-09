//
//  CurrencyConversionError.swift
//  TipGenius
//
//  Created by Wadealanchan on 8/11/2025.
//

import Foundation

/// Errors that can occur during currency conversion operations
enum CurrencyConversionError: LocalizedError {
    case invalidSourceCurrency
    case invalidTargetCurrency
    case currencyRateNotFound(String)
    case invalidExchangeRate
    case repositoryError(CurrencyRepoError)
    
    var errorDescription: String? {
        switch self {
        case .invalidSourceCurrency:
            return "Invalid source currency"
        case .invalidTargetCurrency:
            return "Invalid target currency"
        case .currencyRateNotFound(let currency):
            return "Exchange rate not found for \(currency.uppercased())"
        case .invalidExchangeRate:
            return "Invalid exchange rate"
        case .repositoryError(let error):
            return error.localizedDescription
        }
    }
    
    var failureReason: String? {
        switch self {
        case .invalidSourceCurrency:
            return "The source currency code is empty or invalid"
        case .invalidTargetCurrency:
            return "The target currency code is empty or invalid"
        case .currencyRateNotFound(let currency):
            return "Unable to find exchange rate for \(currency.uppercased()). The currency may not be supported or the rate data may be unavailable."
        case .invalidExchangeRate:
            return "The exchange rate received is invalid (zero or negative)"
        case .repositoryError(let error):
            return error.localizedDescription
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidSourceCurrency, .invalidTargetCurrency:
            return "Please select a valid currency from the list"
        case .currencyRateNotFound:
            return "Try selecting a different currency or check your internet connection"
        case .invalidExchangeRate:
            return "Please try again later or contact support if the problem persists"
        case .repositoryError:
            return "Please try again later"
        }
    }
}

