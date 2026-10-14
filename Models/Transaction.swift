import Foundation

struct Transaction: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var amount: Double
    var type: TransactionType
    var category: String
    var date: Date
    var note: String?
    
    init(id: UUID = UUID(), title: String, amount: Double,
         type: TransactionType, category: String,
         date: Date = Date(), note: String? = nil) {
        self.id = id
        self.title = title
        self.amount = amount
        self.type = type
        self.category = category
        self.date = date
        self.note = note
    }
}

enum TransactionType: String, Codable, CaseIterable {
    case credit = "Credit"
    case debit  = "Debit"
}
