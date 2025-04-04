import SwiftUI

class CoinsManager: ObservableObject {
    static let shared = CoinsManager()
    
    @Published var totalCoins: Int = 1000 {
        didSet {
            UserDefaults.standard.set(totalCoins, forKey: "userCoins")
        }
    }
    
    @Published var transactions: [CoinTransaction] = []
    
    private init() {
        if let savedCoins = UserDefaults.standard.object(forKey: "userCoins") as? Int {
            totalCoins = savedCoins
        }
        
        if let savedTransactions = UserDefaults.standard.data(forKey: "coinTransactions"),
           let decodedTransactions = try? JSONDecoder().decode([CoinTransaction].self, from: savedTransactions) {
            transactions = decodedTransactions
        }
    }
    
    func addCoins(_ amount: Int, reason: String) {
        totalCoins += amount
        
        let transaction = CoinTransaction(amount: amount, isSpending: false, description: reason, date: Date())
        transactions.append(transaction)
        saveTransactions()
    }
    
    func spendCoins(_ amount: Int, reason: String) -> Bool {
        if totalCoins >= amount {
            totalCoins -= amount
            
            let transaction = CoinTransaction(amount: amount, isSpending: true, description: reason, date: Date())
            transactions.append(transaction)
            saveTransactions()
            
            return true
        }
        return false
    }
    
    func purchaseItem(name: String, price: Double) -> Bool {
        let priceInCoins = Int(price)
        return spendCoins(priceInCoins, reason: "Purchased \(name)")
    }
    
    private func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: "coinTransactions")
        }
    }
    
    func clearTransactions() {
        transactions = []
        saveTransactions()
    }
    
    func resetCoins() {
        totalCoins = 1000
        clearTransactions()
    }
}

struct CoinTransaction: Codable, Identifiable {
    var id = UUID()
    let amount: Int
    let isSpending: Bool 
    let description: String
    let date: Date
    
    var formattedAmount: String {
        return isSpending ? "-\(amount)" : "+\(amount)"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct CoinBalanceView: View {
    @ObservedObject var coinsManager = CoinsManager.shared
    
    var body: some View {
        HStack {
            Image(systemName: "dollarsign.circle.fill")
                .foregroundColor(.yellow)
                .font(.title2)
            
            Text("\(coinsManager.totalCoins)")
                .fontWeight(.bold)
        }
        .padding(8)
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(10)
    }
}

struct CoinHistoryView: View {
    @ObservedObject var coinsManager = CoinsManager.shared
    
    var body: some View {
        VStack {
            HStack {
                Text("Current Balance:")
                    .font(.headline)
                
                Spacer()
                
                Text("\(coinsManager.totalCoins)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding()
            
            List {
                ForEach(coinsManager.transactions.sorted(by: { $0.date > $1.date })) { transaction in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(transaction.description)
                                .fontWeight(.medium)
                            
                            Text(transaction.formattedDate)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(transaction.formattedAmount)
                            .fontWeight(.semibold)
                            .foregroundColor(transaction.isSpending ? .red : .green)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Coin History")
    }
}

struct CoinPopupView: View {
    @ObservedObject var coinsManager = CoinsManager.shared
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Your Coins")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    isShowing = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            
            HStack(spacing: 15) {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
                
                Text("\(coinsManager.totalCoins)")
                    .font(.system(size: 40, weight: .bold))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(10)
            
            if !coinsManager.transactions.isEmpty {
                VStack(alignment: .leading) {
                    Text("Recent Transactions")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    ForEach(Array(coinsManager.transactions.sorted(by: { $0.date > $1.date }).prefix(3))) { transaction in
                        HStack {
                            Text(transaction.description)
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Text(transaction.formattedAmount)
                                .font(.subheadline)
                                .foregroundColor(transaction.isSpending ? .red : .green)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            
            NavigationLink(destination: CoinHistoryView()) {
                Text("View Full History")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                isShowing = false
            }) {
                Text("Close")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(30)
    }
}

extension ShoppingViewModel {
    func canPurchase(price: Double) -> Bool {
        return CoinsManager.shared.totalCoins >= Int(price)
    }
    
    func buyWithCoins(plantName: String, price: Double) -> Bool {
        return CoinsManager.shared.purchaseItem(name: plantName, price: price)
    }
}
