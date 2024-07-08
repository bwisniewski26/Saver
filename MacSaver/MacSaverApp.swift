//
//  MacSaverApp.swift
//  MacSaver
//
//  Created by Bartek Wiśniewski on 07/07/2024.
//

import SwiftUI
import SwiftData

@main
struct MacSaverApp: App {
    let container: ModelContainer = {
        let schema = Schema([Purchase.self, dBudget.self, BudgetsManagement.self])
        let container = try! ModelContainer(for: schema, configurations: [])
        return container
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .navigationTitle("Saver")
        }
        .modelContainer(container)
    }
}
