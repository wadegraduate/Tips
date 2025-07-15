import SwiftUI

class CurrencySearchListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedFilter: String = "All"
    @Published var cryptos: [CryptoCurrency] = []
    
    let filters = ["My", "All", "Hot", "USDⓈ", "Meme"]
    
    // Mock data
    private let allCryptos: [CryptoCurrency] = [
        CryptoCurrency(icon: "eth_icon", name: "ETH", network: "BEP20", address: "0x2170...f933f8", amount: "1", isFavorite: true, iconColor: .white),
        CryptoCurrency(icon: "bnb_icon", name: "BNB", network: "BEP20", amount: "0.02779175", iconColor: .yellow),
        CryptoCurrency(icon: "btc_icon", name: "BTC", network: "Bitcoin", iconColor: .orange),
        CryptoCurrency(icon: "usdt_icon", name: "USDT", network: "ERC20", address: "0xdac1...831ec7", iconColor: .green)
    ]
    
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
                $0.name.lowercased().contains(searchText.lowercased()) ||
                ($0.address?.lowercased().contains(searchText.lowercased()) ?? false)
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
