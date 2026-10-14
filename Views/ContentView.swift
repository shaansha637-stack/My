import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: TransactionStore
    @State private var showAdd = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                summaryCard
                
                if store.transactions.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(store.transactions) { txn in
                            TransactionRowView(transaction: txn)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { store.delete(store.transactions[$0]) }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Finance Tracker")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAdd = true } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddTransactionView()
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(spacing: 16) {
            Text("Balance")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(store.balance, format: .currency(code: "USD"))
                .font(.system(size: 42, weight: .bold))
                .foregroundStyle(store.balance >= 0 ? .green : .red)
            
            HStack(spacing: 40) {
                VStack {
                    Label("Credit", systemImage: "arrow.down.circle.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                    Text(store.totalCredit, format: .currency(code: "USD"))
                        .font(.headline)
                }
                VStack {
                    Label("Debit", systemImage: "arrow.up.circle.fill")
                        .foregroundStyle(.red)
                        .font(.caption)
                    Text(store.totalDebit, format: .currency(code: "USD"))
                        .font(.headline)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "tray")
                .font(.system(size: 50))
                .foregroundStyle(.secondary)
            Text("No transactions yet")
                .foregroundStyle(.secondary)
            Text("Tap + to add your first entry")
                .font(.caption)
                .foregroundStyle(.tertiary)
            Spacer()
        }
    }
}
