//
//  currency.swift
//  TipGenius
//
//  Created by Wadealanchan on 6/6/2025.
//

import SwiftUI

struct CurrencyConversionView: View {
    // State variables to hold selected currencies and amounts
    @State private var payCurrency: CryptoCurrency = .default
    @State private var receiveCurrency: CryptoCurrency = CryptoCurrency(icon: "btc_icon", name: "BTC", network: "Bitcoin", amount: nil, iconColor: .orange)
    @State private var payAmountString: String = "0"
    @State private var receiveAmountString: String = "0"
    @State private var selectedCrypto: CryptoCurrency = .default
    
    // Dummy list of available currencies for pickers
    let availableCurrencies: [CryptoCurrency] = [
        CryptoCurrency(icon: "eth_icon", name: "ETH", network: "BEP20", address: "0x2170...f933f8", amount: "1", isFavorite: true, iconColor: .white),
        CryptoCurrency(icon: "btc_icon", name: "BTC", network: "Bitcoin", amount: nil, iconColor: .orange),
        CryptoCurrency(icon: "usdt_icon", name: "USDT", network: "TRC20", amount: "1000.0", iconColor: .green)
        // Add more currencies as needed
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color for the entire view
                Color(red: 28/255, green: 28/255, blue: 30/255) // Approximate dark background color from image
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    PayView(
                        amountString: $payAmountString,
                        selectedCurrency: $payCurrency,
                        availableCurrencies: availableCurrencies
                    )
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer().frame(height: 0) // Placeholder for swap button overlap
                    SwapButton(
                        payCurrency: $payCurrency,
                        receiveCurrency: $receiveCurrency,
                        payAmountString: $payAmountString,
                        receiveAmountString: $receiveAmountString
                    )
                        .padding(.vertical, -15) // Negative padding to overlap slightly
                        .zIndex(1) // Ensure button is on top
                    
                    ReceiveView(
                        selectedCurrency: $receiveCurrency,
                        amountString: $receiveAmountString,
                        availableCurrencies: availableCurrencies
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    Spacer()
                }
            }
            .foregroundColor(.white) // Default text color
            .navigationBarTitle(LocalizedString("Conversion"))
        }
    }
}

// MARK: - Pay Section View

struct PayView: View {
    @Binding var amountString: String
    @Binding var selectedCurrency: CryptoCurrency
    let availableCurrencies: [CryptoCurrency]
    @State private var isShowingCurrencySheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Top row: "Pay" label and percentage buttons
            HStack {
                Text("Pay")
                    .font(.system(size: 20, weight: .semibold))
                
                Spacer()
                
                PercentageButton(label: "MIN", action: {
                    // TODO: Implement MIN logic
                    amountString = "0.01" // Example
                })
                PercentageButton(label: "50%", action: {
                    // TODO: Implement 50% logic
                    let halfBalance = (Double(selectedCurrency.amount ?? "0") ?? 0) / 2
                    amountString = String(format: "%.2f", halfBalance)
                })
                PercentageButton(label: "MAX", action: {
                    // TODO: Implement MAX logic
                    amountString = selectedCurrency.amount ?? "0"
                })
            }
            
            // Middle row: Currency selector and amount input
            HStack(spacing: 15) {
                CurrencySelectorView(
                    selectedCurrency: $selectedCurrency,
                    availableCurrencies: availableCurrencies,
                    onCurrencySelectorTapped: { isShowingCurrencySheet = true }
                )
                Spacer()
                TextField("0", text: $amountString)
                    .font(.system(size: 36, weight: .medium))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: .infinity, alignment: .trailing) // Ensure it takes available space
                    .accessibilityLabel("Pay amount")
            }
            
            .cornerRadius(12)
            .sheet(isPresented: $isShowingCurrencySheet) {
                CurrencySearchListView(selectedCrypto: $selectedCurrency)
            }
            
            // Bottom row: Available balance
            Text("Available balance : \(selectedCurrency.amount ?? "0") \(selectedCurrency.name)")
                .font(.caption)
                .foregroundColor(.gray)
                .padding([.leading, .bottom], 5) // Align with the currency selector
            
        }
        .padding()
        .background(Color(white: 0.15)) // Darker gray for this section background
        .cornerRadius(15)
    }
}

// MARK: - Receive Section View

struct ReceiveView: View {
    @Binding var selectedCurrency: CryptoCurrency
    @Binding var amountString: String
    let availableCurrencies: [CryptoCurrency]
    @State private var isShowingCurrencySheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Top row: "Receive" label
            HStack {
                Text("Receive")
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
            }
            
            // Middle row: Currency selector and amount display
            HStack(spacing: 15) {
                CurrencySelectorView(
                    selectedCurrency: $selectedCurrency,
                    availableCurrencies: availableCurrencies,
                    onCurrencySelectorTapped: { isShowingCurrencySheet = true }
                )
                
                Spacer()
                
                Text(amountString) // Display only for receive, not editable here
                    .font(.system(size: 36, weight: .medium))
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .accessibilityLabel("Receive amount")
                
            }
            .background(Color(white: 0.15))
            .cornerRadius(12)
            .sheet(isPresented: $isShowingCurrencySheet) {
                CurrencySearchListView(selectedCrypto: $selectedCurrency)
            }
            
            // Bottom row: Balance
            Text("Balance : \(selectedCurrency.amount ?? "0") \(selectedCurrency.name)")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading, 5)
        }
        .padding()
        .background(Color(white: 0.15)) // Darker gray for this section background
        .cornerRadius(15)
    }
}

// MARK: - Currency Selector View (Reusable Component)

struct CurrencySelectorView: View {
    @Binding var selectedCurrency: CryptoCurrency
    let availableCurrencies: [CryptoCurrency]
    var onCurrencySelectorTapped: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { onCurrencySelectorTapped?() }) {
            HStack {
                Image(selectedCurrency.icon)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .background(selectedCurrency.iconColor)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    HStack {
                        Text(selectedCurrency.name)
                            .font(.headline)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    Text(selectedCurrency.network)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}


// MARK: - Percentage Button

struct PercentageButton: View {
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(white: 0.25)) // Darker gray for buttons
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle()) // Removes default button styling if needed
    }
}

// MARK: - Swap Button

struct SwapButton: View {
    @Binding var payCurrency: CryptoCurrency
    @Binding var receiveCurrency: CryptoCurrency
    @Binding var payAmountString: String
    @Binding var receiveAmountString: String

    var body: some View {
        Button(action: {
            (payCurrency, receiveCurrency) = (receiveCurrency, payCurrency)
            (payAmountString, receiveAmountString) = (receiveAmountString, payAmountString)
        }) {
            Image(systemName: "arrow.up.arrow.down")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(15)
                .background(Color.blue) // Blue color from the image
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
    }
}

// MARK: - Preview

struct CryptoExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConversionView()
            .preferredColorScheme(.dark) // Ensure preview is in dark mode
    }
}

// MARK: - Placeholder Image Extensions (if using custom images)
// If you have actual image assets (e.g., ethereum_logo.png, bitcoin_logo.png) in your asset catalog,
// you can use them directly: Image("ethereum_logo")
// For this example, I've used SF Symbols as placeholders.

// Example how you might define custom images if not using SF Symbols
#if DEBUG
//struct Image { // This is a placeholder to avoid errors if you don't have these images.
//    static func ethereum_logo() -> SwiftUI.Image { SwiftUI.Image(systemName: "e.circle.fill") }
//    static func bitcoin_logo() -> SwiftUI.Image { SwiftUI.Image(systemName: "b.circle.fill") }
//    static func usdt_logo() -> SwiftUI.Image { SwiftUI.Image(systemName: "u.circle.fill") }
//}
#endif

