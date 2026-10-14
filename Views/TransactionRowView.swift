import SwiftUI

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            Circle()
                .fill(transaction.type == .credit ? .green.opacity(0.2) : .red.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: transaction.type == .credit
                          ? "arrow.down" : "arrow.up")
                        .foregroundStyle(transaction.type == .credit ? .green : .red)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title).font(.body)
                Text("\(transaction.category) • \(transaction.date, style: .date)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text((transaction.type == .credit ? "+" : "-") +
                 transaction.amount.formatted(.currency(code: "USD")))
                .font(.headline)
                .foregroundStyle(transaction.type == .credit ? .green : .red)
        }
    }
}
