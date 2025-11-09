//
//  CurrencySearchList.swift
//  TipGenius
//
//  Created by Wadealanchan on 6/6/2025.
//

import SwiftUI

// MARK: - Main View

struct CurrencySearchListView: View {
    @Binding var selectedCrypto: FiatCurrency
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CurrencySearchListViewModel()
    
    var body: some View {
        ZStack {
            // Background
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Pay")
                        .font(.title2).bold()
                        .foregroundColor(.standardText)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.standardText)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Enter token name or token contract address", text: $viewModel.searchText)
                        .foregroundColor(.standardText)
                        .onChange(of: viewModel.searchText) { newValue in
                            viewModel.updateSearchText(newValue)
                        }
                }
                .padding()
                .background(.secondaryCardViewBackground)
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Filter Buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.filters, id: \.self) { filter in
                            Button(action: {
                                viewModel.updateFilter(filter)
                            }) {
                                Text(filter)
                                    .font(.headline)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(viewModel.selectedFilter == filter ? Color.blue : .secondaryCardViewBackground)
                                    .foregroundColor(.standardText)
                                    .cornerRadius(18)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                

                // In Wallet Section
                VStack {
                    HStack {
                        Text("In Wallet")
                            .font(.headline)
                            .foregroundColor(.standardText)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Crypto List
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(viewModel.cryptos) { crypto in
                                Button(action: {
                                    selectedCrypto = crypto
                                    dismiss()
                                }) {
                                    CryptoRow(crypto: crypto)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

// MARK: - Reusable Row View

struct CryptoRow: View {
    let icon: String
    let name: String
    var amount: String? = nil
    var isFavorite: Bool = false

    // Convenience initializer
    init(crypto: FiatCurrency) {
        self.icon = crypto.icon
        self.name = crypto.name
        self.amount = crypto.amount
        self.isFavorite = crypto.isFavorite
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(icon) // Placeholder for crypto icons
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.standardText)
                }
            }
            
            Spacer()
            
            if let amt = amount {
                Text(amt)
                    .font(.headline)
                    .foregroundColor(.standardText)
            }
            
            Image(systemName: isFavorite ? "star.fill" : "star")
                .foregroundColor(isFavorite ? .yellow : .gray)
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview

struct CryptoPayView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySearchListView(selectedCrypto: .constant(.default))
    }
}

