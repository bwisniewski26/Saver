//
//  SaverApp.swift
//  Saver
//
//  Created by Bartek Wiśniewski on 19/01/2024.
//

import SwiftUI
import SwiftData

@main
struct SaverApp: App {
    
    let container: ModelContainer = {
        let schema = Schema([Purchase.self, dBudget.self, BudgetsManagement.self])
        let container = try! ModelContainer(for: schema, configurations: [])
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            mainPage()
        }
        .modelContainer(container)
    }
}
