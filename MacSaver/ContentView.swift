//
//  ContentView.swift
//  MacSaver
//
//  Created by Bartek Wiśniewski on 07/07/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink("Budgets", destination: budgets())
                NavigationLink("Purchases", destination: purchases())
            }
            .navigationSplitViewColumnWidth(min: 150, ideal: 160)
        } detail: {
            Text("Select option")
                .font(.title)
        }
    }

}

#Preview {
    ContentView()
}
