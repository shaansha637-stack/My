import SwiftUI

struct AddTransactionView: View {
    @EnvironmentObject var store: TransactionStore
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var amount = ""
    @State private var type: TransactionType = .debit
    @State private var category = "General"
    @State private var date = Date()
    
    let categories = ["General", "Food", "Transport", "Salary",
                      "Bills", "Shopping", "Entertainment", "Other"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    Picker("Type", selection: $type) {
                        ForEach(TransactionType.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Category & Date") {
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { Text($0) }
                    }
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("New Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(title.isEmpty || Double(amount) == nil)
                }
            }
        }
    }
    
    private func save() {
        guard let value = Double(amount), !title.isEmpty else { return }
        store.add(Transaction(title: title, amount: value,
                              type: type, category: category, date: date))
        dismiss()
    }
}
