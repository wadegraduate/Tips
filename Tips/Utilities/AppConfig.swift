//
//  AppConfig.swift
//  TipGenius
//
//  Created by Wadealanchan on 8/11/2025.
//

import Foundation

/// Configuration helper for reading app configuration values
struct AppConfig {
    /// Reads a value from Info.plist
    /// - Parameter key: The key to look up in Info.plist
    /// - Returns: The value as a String, or nil if not found
    static func value(for key: String) -> String? {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let value = plist[key] as? String else {
            return nil
        }
        return value
    }
    
    /// Gets the Open Exchange Rates API App ID from Info.plist
    /// - Returns: The App ID string, or nil if not found
    static var openExchangeRatesAppID: String? {
        return value(for: "OpenExchangeRatesAppID")
    }
}

