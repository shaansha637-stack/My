import Foundation

@MainActor
class TransactionStore: ObservableObject {
    @Published var transactions: [Transaction] = [] {
        didSet { save() }
    }
    
    private let key = "finance_transactions"
    
    init() { load() }
    
    var totalCredit: Double {
        transactions.filter { $0.type == .credit }.reduce(0) { $0 + $1.amount }
    }
    
    var totalDebit: Double {
        transactions.filter { $0.type == .debit }.reduce(0) { $0 + $1.amount }
    }
    
    var balance: Double { totalCredit - totalDebit }
    
    func add(_ transaction: Transaction) {
        transactions.insert(transaction, at: 0)
    }
    
    func delete(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let items = try? JSONDecoder().decode([Transaction].self, from: data)
        else { return }
        transactions = items
    }
}
