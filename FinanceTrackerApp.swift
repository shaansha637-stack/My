import SwiftUI

@main
struct FinanceTrackerApp: App {
    @StateObject private var store = TransactionStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
