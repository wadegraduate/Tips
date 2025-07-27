//
//  CurrencyConversionService.swift
//  TipGenius
//
//  Created by Wadealanchan on 27/7/2025.
//
import Foundation

protocol CurrencyServiceProtocol {
    func getExchangeRate(from: String, to: String) async throws -> Double
}

// MARK: - Currency Service Implementation
class CurrencyService: CurrencyServiceProtocol {
    func getExchangeRate(from: String, to: String) async throws -> Double {
        // TODO: Implement actual API call to get exchange rate
        // For now, return a mock rate
        // You can integrate with services like CoinGecko, Binance, or other crypto APIs
        
        // Mock implementation - replace with actual API call
        let mockRates: [String: Double] = [
            "ETH_BTC": 0.065,
            "BTC_ETH": 15.38,
            "ETH_USDT": 2500.0,
            "USDT_ETH": 0.0004,
            "BTC_USDT": 45000.0,
            "USDT_BTC": 0.000022
        ]
        
        let key = "\(from)_\(to)"
        return mockRates[key] ?? 1.0
    }
} 
