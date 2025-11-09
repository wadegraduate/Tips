//
//  CurrencyRepo.swift
//  TipGenius
//
//  Created by Wadealanchan on 8/11/2025.
//

import Foundation

// MARK: - Repository Protocol

protocol CurrencyRepoProtocol {
    /// Fetches currency exchange rates for a given base currency code
    /// - Parameters:
    ///   - currencyCode: The base currency code (e.g., "usd", "eur")
    ///   - date: Optional date string in format "YYYY-MM-DD". If nil, uses current date
    /// - Returns: CurrencyRatesResponse containing date and exchange rates
    /// - Throws: NetworkError or decoding errors
    func fetchCurrencyRates(for currencyCode: String, date: String?) async throws -> CurrencyRatesResponse
}

// MARK: - Repository Implementation

class CurrencyRepo: CurrencyRepoProtocol {
    // MARK: - Properties
    
    private let baseURL = "https://openexchangerates.org/api/latest.json"
    private let urlSession: URLSession
    private let appID: String = "d88b1f55961b485290ff272d211e5b6b"
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    // MARK: - Public Methods
    
    func fetchCurrencyRates(for currencyCode: String, date: String? = nil) async throws -> CurrencyRatesResponse {
        // Validate currency code
        guard !currencyCode.isEmpty else {
            throw CurrencyRepoError.invalidCurrencyCode
        }
        
        // Validate app ID
        guard !appID.isEmpty else {
            throw CurrencyRepoError.missingAppID
        }
        
        // Construct URL with query parameters
        var urlComponents = URLComponents(string: baseURL)
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "base", value: currencyCode.uppercased())
        ]
        
        // Add date parameter if provided
        if let date = date {
            queryItems.append(URLQueryItem(name: "date", value: date))
        }
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            throw CurrencyRepoError.invalidURL
        }
        
        // Create request with Authorization header
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Token \(appID)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Make API request
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            // Validate response
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw CurrencyRepoError.invalidResponse
            }
            
            // Decode response
            let decoder = JSONDecoder()
            do {
                let currencyResponse = try decoder.decode(CurrencyRatesResponse.self, from: data)
                return currencyResponse
            } catch {
                throw CurrencyRepoError.decodingError(error)
            }
        } catch let error as CurrencyRepoError {
            throw error
        } catch {
            throw CurrencyRepoError.networkError(error)
        }
    }
}
