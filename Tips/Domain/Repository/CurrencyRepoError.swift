//
//  CurrencyRepoError.swift
//  TipGenius
//
//  Created by Wadealanchan on 8/11/2025.
//

import Foundation

enum CurrencyRepoError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)
    case invalidCurrencyCode
    case missingAppID
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidCurrencyCode:
            return "Invalid currency code"
        case .missingAppID:
            return "App ID is required for API authentication"
        }
    }
}

