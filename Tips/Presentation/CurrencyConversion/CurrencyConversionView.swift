//
//  currency.swift
//  TipGenius
//
//  Created by Wadealanchan on 6/6/2025.
//

import SwiftUI

enum Field {
    case pay
    case receive
}

struct CurrencyConversionView: View {
    @StateObject private var viewModel = CurrencyConversionViewModel()
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color for the entire view
//                Color(red: 28/255, green: 28/255, blue: 30/255) // Approximate dark background color from image
//                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    PayView(
                        amountString: $viewModel.payAmountString,
                        selectedCurrency: $viewModel.payCurrency,
                        availableCurrencies: viewModel.availableCurrencies,
                        viewModel: viewModel,
                        focusedField: $focusedField
                    )
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer().frame(height: 0) // Placeholder for swap button overlap
                    SwapButton(viewModel: viewModel)
                        .padding(.vertical, -15) // Negative padding to overlap slightly
                        .zIndex(1) // Ensure button is on top
                    
                    ReceiveView(
                        selectedCurrency: $viewModel.receiveCurrency,
                        amountString: $viewModel.receiveAmountString,
                        availableCurrencies: viewModel.availableCurrencies,
                        viewModel: viewModel,
                        focusedField: $focusedField
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    // Loading indicator
                    if viewModel.isLoading {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Fetching exchange rate...")
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                    
                    // Error message
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding()
                    }
                    
                    Spacer()
                }
            }
            //.foregroundColor(.white) // Default text color
            .navigationBarTitle(LocalizedString("Conversion"))
            .task {
                await viewModel.fetchExchangeRate()
            }
            .onChange(of: viewModel.payCurrency) { _ in
                Task {
                    await viewModel.fetchExchangeRate()
                }
            }
            .onChange(of: viewModel.receiveCurrency) { _ in
                Task {
                    await viewModel.fetchExchangeRate()
                }
            }
//            .onChange(of: focusedField) { newFocus in
//                // Update the ViewModel's editing state based on focus
//                viewModel.isPayEditing = newFocus == .pay
//                viewModel.isReceiveEditing = newFocus == .receive
//            }
        }
    }
}

// MARK: - Pay Section View

struct PayView: View {
    @Binding var amountString: String
    @Binding var selectedCurrency: FiatCurrency
    let availableCurrencies: [FiatCurrency]
    let viewModel: CurrencyConversionViewModel
    @FocusState.Binding var focusedField: Field?
    @State private var isShowingCurrencySheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Top row: "Pay" label and percentage buttons
            HStack {
                Text("Pay")
                    .foregroundStyle(.standardText)
                    //.font(.system(size: 20, weight: .semibold))
                Spacer()
                
                PercentageButton(label: "50%", action: {
                    viewModel.setHalfAmount()
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
                    .focused($focusedField, equals: .pay)
                
            }
            .cornerRadius(12)
            .sheet(isPresented: $isShowingCurrencySheet) {
                CurrencySearchListView(selectedCrypto: $selectedCurrency)
            }
            
            // Bottom row: Available balance
            Text("Available balance : \(selectedCurrency.amount) \(selectedCurrency.name)")
                .font(.caption)
                .foregroundColor(.gray)
                .padding([.leading, .bottom], 5) // Align with the currency selector
            
        }
        .padding()
        .background(.cardViewBackground) // Darker gray for this section background
        .cornerRadius(15)
    }
}

// MARK: - Receive Section View

struct ReceiveView: View {
    @Binding var selectedCurrency: FiatCurrency
    @Binding var amountString: String
    let availableCurrencies: [FiatCurrency]
    let viewModel: CurrencyConversionViewModel
    @FocusState.Binding var focusedField: Field?
    @State private var isShowingCurrencySheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Top row: "Receive" label
            HStack {
                Text("Receive")
                    .foregroundStyle(.standardText)
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
                
                TextField("0", text: $amountString)
                    .font(.system(size: 36, weight: .medium))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: .infinity, alignment: .trailing) // Ensure it takes available space
                    .accessibilityLabel("Receive amount")
                    .focused($focusedField, equals: .receive)
                
            }
            .cornerRadius(12)
            .sheet(isPresented: $isShowingCurrencySheet) {
                CurrencySearchListView(selectedCrypto: $selectedCurrency)
            }
            
            // Bottom row: Balance
            Text("Balance : \(selectedCurrency.amount) \(selectedCurrency.name)")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading, 5)
        }
        .padding()
        .background(.cardViewBackground)
        .cornerRadius(15)
    }
}

// MARK: - Currency Selector View (Reusable Component)

struct CurrencySelectorView: View {
    @Binding var selectedCurrency: FiatCurrency
    let availableCurrencies: [FiatCurrency]
    var onCurrencySelectorTapped: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { onCurrencySelectorTapped?() }) {
            HStack {
                Image(selectedCurrency.icon)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    HStack {
                        Text(selectedCurrency.name)
                            .font(.headline)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .foregroundColor(.standardText)
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
                .background(.secondaryCardViewBackground) // Darker gray for buttons
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle()) // Removes default button styling if needed
    }
}

// MARK: - Swap Button

struct SwapButton: View {
    let viewModel: CurrencyConversionViewModel

    var body: some View {
        Button(action: {
            viewModel.swapCurrencies()
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
    }
}


