import SwiftUI

class CurrencySearchListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedFilter: String = "All"
    @Published var cryptos: [FiatCurrency] = []
    
    let filters = ["My", "All", "Hot", "USDⓈ", "Meme"]
    
    // Mock data
    private let allCryptos: [FiatCurrency] = mockCurrency
    
    init() {
        self.cryptos = allCryptos
    }
    
    func filterCryptos() {
        var filtered = allCryptos
        if selectedFilter == "My" {
            filtered = allCryptos.filter { $0.isFavorite }
        } else if selectedFilter == "Hot" {
            filtered = allCryptos.filter { $0.name == "ETH" || $0.name == "BTC" }
        } else if selectedFilter == "USDⓈ" {
            filtered = allCryptos.filter { $0.name == "USDT" }
        } else if selectedFilter == "Meme" {
            filtered = [] // No meme coins in mock
        }
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        self.cryptos = filtered
    }
    
    func updateFilter(_ filter: String) {
        selectedFilter = filter
        filterCryptos()
    }
    
    func updateSearchText(_ text: String) {
        searchText = text
        filterCryptos()
    }
} 
