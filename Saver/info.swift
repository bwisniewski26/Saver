//
//  info.swift
//  Saver
//
//  Created by Bartek Wiśniewski on 09/03/2024.
//

import SwiftUI
import SwiftData



struct info: View {
    
    @Environment(\.modelContext) var context
    @Query(sort: \dBudget.currentBudget) var budget: [dBudget]
    @Query(sort: \Purchase.price) var purchases: [Purchase]
    @State private var isShowingBudgetSheet = false
    @State private var expenses: Double = 0
    var body: some View {
        NavigationStack {
            
            if !budget.isEmpty {
                ScrollView {
                    VStack {
                        Text("How are your finances doing?")
                            .foregroundColor(.accentColor)
                            .font(.title)
                        
                        Text("Your monthly budget is \(budget[0].initialBudget, specifier: "%.2f")PLN")
                            .font(.title2)
                            .opacity(0.6)
                        Button("Change your budget information") {
                            isShowingBudgetSheet = true
                        }
                        .opacity(0.5)
                        
                    }
                    Spacer()
                    HStack {
                        VStack {
                            if (budget[0].currentBudget > 0) {
                                Text("\(budget[0].currentBudget, specifier: "%.2f")PLN")
                                    .foregroundColor(.green)
                            } else {
                                Text("\(budget[0].currentBudget, specifier: "%.2f")PLN")
                                    .foregroundColor(.red)
                            }
                            Text("How much money do you have")
                                .opacity(0.6)
                        }
                        VStack {
                            if (budget[0].currentSavings == 0) {
                                Text("\(budget[0].currentSavings * (budget[0].initialBudget-budget[0].currentBudget), specifier: "%.2f")PLN")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(budget[0].currentSavings * (budget[0].initialBudget-budget[0].currentBudget), specifier: "%.2f")PLN")
                                    .foregroundColor(.green)
                            }
                            Text("How much money you've saved")
                                .opacity(0.6)
                            
                        }
                    } .offset(y:75)
                    
                }
                .sheet(isPresented: $isShowingBudgetSheet) { SetBudget() }
                .defaultScrollAnchor(.bottom)
            } else {
                ContentUnavailableView(label: {
                    Label("Budget info empty.", systemImage: "doc.questionmark.fill")
                }, description: {
                    Text("Fill your budget information.")
                }, actions: {
                    Button("Budget info") {
                        isShowingBudgetSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                })
                .offset(y: -60)
            }
        }
        .sheet(isPresented: $isShowingBudgetSheet) { SetBudget() }
    }
}

struct SetBudget: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    @State private var monthlyBudget: Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Text("Monthly budget")
                TextField("", value: $monthlyBudget, format: .currency(code: "PLN"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Budget information")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        let newBudget = dBudget(currentBudget: monthlyBudget, currentSavings: 0.0, initialBudget: monthlyBudget)
                        context.insert(newBudget)
                        
                        dismiss()
                    }
                }
            }
        }
    }
    
}

#Preview {
    info()
}
