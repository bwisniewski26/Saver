//
//  settings.swift
//  Saver
//
//  Created by Bartek Wiśniewski on 09/03/2024.
//

import SwiftUI
import SwiftData

struct settings: View {
    @Environment(\.modelContext) var context
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: setSavingPercentage()) {
                    HStack {
                        Image(systemName: "banknote")
                            .font(.title2)
                        Text("Set saving percentage")
                    }
                }
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct setSavingPercentage: View {
    @Query(sort: \dBudget.currentBudget) var budget: [dBudget]
    @State private var percentage: Double = 0
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    var body: some View {
        if !budget.isEmpty {
            Form {
                TextField("", value: $percentage, format: .number)
                    .keyboardType(.decimalPad)
            }
            Button("Save") {
                
                budget[0].currentSavings = percentage/100
                dismiss()
            }
        } else {
            ContentUnavailableView(label: {
                Label("Budget info empty.", systemImage: "doc.questionmark.fill")
            }, description: {
                Text("Fill your budget information.")
            })
            .offset(y: -60)
        }
    }
}

#Preview {
    settings()
}
