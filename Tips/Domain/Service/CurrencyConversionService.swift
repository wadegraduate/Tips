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
    
    let currencyRepo: CurrencyRepoProtocol
    
    init(currencyRepo: CurrencyRepoProtocol = CurrencyRepo()) {
        self.currencyRepo = currencyRepo
    }
    
    func getExchangeRate(from: String, to: String) async throws -> Double {
        // Validate input currency codes
        let fromCurrency = from.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let toCurrency = to.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        guard !fromCurrency.isEmpty else {
            throw CurrencyConversionError.invalidSourceCurrency
        }
        
        guard !toCurrency.isEmpty else {
            throw CurrencyConversionError.invalidTargetCurrency
        }
        
        // If currencies are the same, return 1.0
        guard fromCurrency != toCurrency else {
            return 1.0
        }
        
        // Fetch currency rates from repository
        do {
            let response = try await currencyRepo.fetchCurrencyRates(for: fromCurrency, date: nil)
            
            // Look up the rate for the target currency (case-insensitive lookup)
         
            guard let exchangeRate = response.rates[toCurrency] else {
                throw CurrencyConversionError.currencyRateNotFound(toCurrency)
            }
            
            // Validate that the rate is a positive number
            guard exchangeRate > 0 else {
                throw CurrencyConversionError.invalidExchangeRate
            }
            
            return exchangeRate
        } catch let error as CurrencyRepoError {
            // Convert repository errors to service errors
            throw CurrencyConversionError.repositoryError(error)
        } catch let error as CurrencyConversionError {
            // Re-throw service errors as-is
            throw error
        } catch {
            // Wrap any other errors as repository errors
            throw CurrencyConversionError.repositoryError(.networkError(error))
        }
    }
} 
