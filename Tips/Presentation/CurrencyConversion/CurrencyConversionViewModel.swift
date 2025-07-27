//
//  CurrencyConversionViewModel.swift
//  TipGenius
//
//  Created by Wadealanchan on 6/6/2025.
//

import Foundation
import Combine

@MainActor
class CurrencyConversionViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var payCurrency: FiatCurrency = .default
    @Published var receiveCurrency: FiatCurrency = FiatCurrency(icon: "btc_icon", name: "BTC", amount: "0", iconColor: .orange)
    @Published var payAmountString: String = "0"
    @Published var receiveAmountString: String = "0"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var exchangeRate: Double = 1.0
    @Published var isPayAmountEditing: Bool = false
    @Published var isReceiveAmountEditing: Bool = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let currencyService: CurrencyServiceProtocol
    
    // MARK: - Available Currencies
    let availableCurrencies: [FiatCurrency] = [
        FiatCurrency(icon: "eth_icon", name: "ETH", amount: "1", isFavorite: true, iconColor: .white),
        FiatCurrency(icon: "btc_icon", name: "BTC", amount: "0", iconColor: .orange),
        FiatCurrency(icon: "usdt_icon", name: "USDT", amount: "1000.0", iconColor: .green)
        // Add more currencies as needed
    ]
    
    // MARK: - Initialization
    init(currencyService: CurrencyServiceProtocol = CurrencyService()) {
        self.currencyService = currencyService
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        // Monitor changes to pay amount and currencies to update receive amount
        Publishers.CombineLatest4($payAmountString, $payCurrency, $receiveCurrency, $isPayAmountEditing)
            .sink { [weak self] payAmount, payCurrency, receiveCurrency, isEditing in
                // Only update receive amount if user is not editing pay amount
                if !isEditing {
                    self?.updateReceiveAmount(payAmount: payAmount, from: payCurrency, to: receiveCurrency)
                }
            }
            .store(in: &cancellables)
        
        // Monitor changes to receive amount and currencies to update pay amount
        Publishers.CombineLatest4($receiveAmountString, $payCurrency, $receiveCurrency, $isReceiveAmountEditing)
            .sink { [weak self] receiveAmount, payCurrency, receiveCurrency, isEditing in
                // Only update pay amount if user is not editing receive amount
                if !isEditing {
                    self?.updatePayAmount(receiveAmount: receiveAmount, from: receiveCurrency, to: payCurrency)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    /// Swap currencies and amounts
    func swapCurrencies() {
        let tempCurrency = payCurrency
        payCurrency = receiveCurrency
        receiveCurrency = tempCurrency
        
        let tempAmount = payAmountString
        payAmountString = receiveAmountString
        receiveAmountString = tempAmount
    }
    
    /// Set percentage of available balance for pay amount
    func setPayAmountPercentage(_ percentage: Double) {
        guard let balance = Double(payAmountString) else {
            payAmountString = "0"
            return
        }
        print(balance)
        let amount = balance * percentage
        payAmountString = String(format: "%.2f", amount)
    }
    
    /// Set 50% of available balance
    func setHalfAmount() {
        setPayAmountPercentage(0.5)
    }
    
    /// Fetch exchange rate for the current currency pair
    func fetchExchangeRate() async {
        guard payCurrency.name != receiveCurrency.name else {
            exchangeRate = 1.0
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let rate = try await currencyService.getExchangeRate(
                from: payCurrency.name,
                to: receiveCurrency.name
            )
            exchangeRate = rate
        } catch {
            errorMessage = "Failed to fetch exchange rate: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Private Methods
    
    private func updateReceiveAmount(payAmount: String, from payCurrency: FiatCurrency, to receiveCurrency: FiatCurrency) {
        guard let amount = Double(payAmount), amount > 0 else {
            receiveAmountString = "0"
            return
        }
        
        let convertedAmount = amount * exchangeRate
        receiveAmountString = String(format: "%.3f", convertedAmount)
    }
    
    private func updatePayAmount(receiveAmount: String, from receiveCurrency: FiatCurrency, to payCurrency: FiatCurrency) {
        guard let amount = Double(receiveAmount), amount > 0 else {
            payAmountString = "0"
            return
        }
        
        let convertedAmount = amount / exchangeRate
        payAmountString = String(format: "%.3f", convertedAmount)
    }
}


