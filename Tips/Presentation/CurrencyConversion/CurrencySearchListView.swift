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
            Color(red: 25/255, green: 25/255, blue: 28/255).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Pay")
                        .font(.title2).bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Enter token name or token contract address", text: $viewModel.searchText)
                        .foregroundColor(.white)
                        .onChange(of: viewModel.searchText) { newValue in
                            viewModel.updateSearchText(newValue)
                        }
                }
                .padding()
                .background(Color(red: 45/255, green: 45/255, blue: 48/255))
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
                                    .background(viewModel.selectedFilter == filter ? Color.blue : Color(red: 45/255, green: 45/255, blue: 48/255))
                                    .foregroundColor(.white)
                                    .cornerRadius(18)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Bank Banner
                HStack {
                    Text("Swap USD to cryptos via SafePal banking gateway with 0 service fee.")
                        .font(.footnote)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(red: 45/255, green: 45/255, blue: 48/255))
                .cornerRadius(12)
                .padding(.horizontal)

                // In Wallet Section
                VStack {
                    HStack {
                        Text("In Wallet")
                            .font(.headline)
                            .foregroundColor(.white)
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
    let iconColor: Color

    // Convenience initializer
    init(crypto: FiatCurrency) {
        self.icon = crypto.icon
        self.name = crypto.name
        self.amount = crypto.amount
        self.isFavorite = crypto.isFavorite
        self.iconColor = crypto.iconColor
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(icon) // Placeholder for crypto icons
                .resizable()
                .frame(width: 40, height: 40)
                .background(iconColor)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            if let amt = amount {
                Text(amt)
                    .font(.headline)
                    .foregroundColor(.white)
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


