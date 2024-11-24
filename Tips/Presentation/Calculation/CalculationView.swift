//
//  CalculationView.swift
//  tips
//
//  Created by Wadealanchan on 24/2/2024.
//

import SwiftUI
import Combine

struct CalculationView: View {
    
    @StateObject var viewModel = CalculationViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                amount
                tipAmount
                billTotals
                reset
            }
            .scrollContentBackground(.hidden)
            .background(Color.theme.background)
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle(LocalizedString( "Tips"))
        }
    }
    
    
    var amount: some View {
        Section {
            HStack {
                Text(defaultCurrency + "$")
                    .font(.system(size: 30, weight: .medium))
                CurrencyTextField(value: $viewModel.billAmount, placeholder: LocalizedString( "Amount"))
            }
            .listRowBackground(Color.theme.secondaryBackground)
            
        } header: {
            Text(LocalizedString( "Amount"))
                .font(.system(size: 20, weight: .medium))
        }
    }
    
    var billTotals: some View {
        Section {
            LabeledAmountView(localisedString: "Subtotal", value: viewModel.billAmount ?? 0)
            LabeledAmountView(localisedString: "Tip", value: viewModel.tipAmount)
            LabeledAmountView(localisedString: "Total With Tip", value: viewModel.totalAmountWithTip)
        } header: {
            Text(LocalizedString( "Bill Totals"))
                .font(.system(size: 20, weight: .medium))
        }
        
    }
    
    var tipAmount: some View {
        Section {
            HStack {
                Slider(value: $viewModel.tipPercentage, in: 0...30, step: 1)
                    .accessibilityLabel(LocalizedString("Tip Percentage Selection"))
                    .accessibilityHint(LocalizedString("Selects the Tip Percentage"))
                Text("\(viewModel.tipPercentage, specifier: "%.0f")%")
                    .frame(width: 40, alignment: .trailing)
            }
            .listRowBackground(Color.theme.secondaryBackground)
            .frame(height: 50)
            
            tipAmountSelection
        } header: {
            Text(LocalizedString("Tip Amount"))
                .font(.system(size: 20, weight: .medium))
        }
    }
    
    var tipAmountSelection: some View {
        ScrollView(.horizontal) {
            HStack {
                Spacer()
                ForEach(viewModel.tipPercentages, id: \.self) { percentage in
                    Button(action: {
                        viewModel.selectTipPercentage(percentage: percentage)
                    }, label: {
                        Text(percentage.toStringWithPercentageSymbol)
                            .frame(width: 35)
                    })
                    .foregroundColor(Color.theme.standardText)
                    .padding()
                    .background(Color.theme.secondaryBlue)
                    .cornerRadius(10)
                }
                Spacer()
            }
        }
        .listRowBackground(Color.theme.secondaryBackground)
    }
    
    var reset: some View {
        Section {
            HStack {
                Button(action: {
                    viewModel.resetValues()
                }, label: {
                    Spacer()
                    Text(LocalizedString( "Reset"))
                        .foregroundColor(Color.theme.red)
                    Spacer()
                })
                .foregroundColor(.white)
                .buttonStyle(.plain)
            }
            .contentShape(Rectangle())
            .listRowBackground(Color.theme.secondaryBackground)
            .onTapGesture {
                viewModel.resetValues()
            }
        }
    }
}

#Preview {
    CalculationView()
}
