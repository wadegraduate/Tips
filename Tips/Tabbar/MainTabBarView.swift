//
//  MainTabBarView.swift
//  SwiftUICryptoProject
//
//  Created by Wadealanchan on 24/1/2024.
//

import SwiftUI

struct MainTabBarView: View {
    
    @State private var selectedTab: Tab = .tipCalculator
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CalculationView()
                .tabItem {
                    Label(LocalizedString("Tip Calculator"), systemImage: "dollarsign.circle")
                }
                .tag(Tab.tipCalculator)
            
            TodoListView(viewModel: TodoListViewModel())
                //.environmentObject(TodoListModel())
                .tabItem {
                    Label(LocalizedString("To-Do List"), systemImage: "list.bullet")
                }
                .tag(Tab.toDoList)
            
            CurrencyConversionView()
                .tabItem {
                    Label(LocalizedString("Currency Conversion"), systemImage: "arrow.left.arrow.right.circle")
                }
                .tag(Tab.currencyConversion)
        }
    }
}

extension MainTabBarView {
    
    var tabBar: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        selectedTab = .tipCalculator
                    }
                }, label: {
                    MainTabBarItemView(tab: .tipCalculator, isSelected: selectedTab == .tipCalculator)
                })
                Spacer()
                
                Button(action: {
                    withAnimation {
                        selectedTab = .toDoList
                    }
                }, label: {
                    MainTabBarItemView(tab: .toDoList, isSelected: selectedTab == .toDoList)
                })
                Spacer()
                
            }
            .padding(.bottom, 20)
        }
        .frame(height: 100)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.theme.tabbarColor)
        }
    }
}


#Preview {
    MainTabBarView()
}
