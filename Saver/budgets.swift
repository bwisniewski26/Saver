//
//  budgets.swift
//  Saver
//
//  Created by Bartek Wiśniewski on 06/07/2024.
//

import SwiftUI
import SwiftData

struct budgets: View {
    @Environment(\.modelContext) var context
    @Query(sort: \dBudget.id) var budgets: [dBudget]
    @Query(sort: \BudgetsManagement.currentId) var currentBudget: [BudgetsManagement]
    @Query(sort: \Purchase.budgetId) var purchases: [Purchase]
    @State private var budgetToShow: dBudget?
    @State private var isShowingBudgetSheet = false
    var body: some View {
        VStack {
            if (!budgets.isEmpty)
            {
                List {
                    ForEach(budgets) { budget in
                        budgetInfo(budget: budget)
                            .onTapGesture {
                                budgetToShow = budget
                            }
                    }
                    .onDelete { budgetSet in
                        for budget in budgetSet {
                            for purchase in purchases
                            {
                                if budgets[budget].purchases.contains(purchase)
                                {
                                    purchase.budgetId = nil
                                }
                            }
                            context.delete(budgets[budget])
                            if (budgets.count > 0)
                            {
                                currentBudget[0].currentId = budgets[budgets.count-1].id
                            }
                            else {
                                context.delete(currentBudget[0])
                            }
                        }
                    }
                }
            }
            else {
                ContentUnavailableView(label: {
                    Label("Budget list empty.", systemImage: "doc.questionmark.fill")
                }, description: {
                    Text("Add your budgets to track your savings.")
                }, actions: {
                    Button("Add budget") {
                        isShowingBudgetSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                )
                .offset(y:-60)

        }
        
        }
        .navigationTitle("Your budgets")
        .sheet(isPresented: $isShowingBudgetSheet)
        {
            AddBudget()
        }
        .sheet(item: $budgetToShow) { budget in
            ShowBudget(budget: budget)
        }
        .toolbar {
            Button("New budget", systemImage: "banknote")
            {
                isShowingBudgetSheet = true
            }
        }
    }
    
}

struct budgetInfo: View {
    let budget: dBudget
    var body: some View {
        HStack{
            Image(systemName: "banknote")
            Text("ID: \(budget.id)")
                .font(.title2)
                .bold()
            Spacer()
            Text("Money left: \(budget.currentBudget, format: .currency(code:"PLN"))")
                .opacity(0.6)
            }
    }
}

struct AddBudget: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    @State private var initial: Double = 0.0
    @State private var initialString: String = ""
    @State private var budId: Int = 0
    @Query() var currentBudget: [BudgetsManagement]
    var body: some View {
        NavigationStack {
            Form {
                TextField("Initial money", value: $initial, format: .currency(code: "PLN"))
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Add budget")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
            
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if (currentBudget.isEmpty)
                        {
                            let budInfo = BudgetsManagement(lastId: 0)
                            context.insert(budInfo)
                            let newBudget = dBudget(id: budId, currentBudget: initial, currentSavings: 0.0, initialBudget: initial)
                            context.insert(newBudget)
                        }
                        else {
                            let budId = currentBudget[0].currentId + 1
                            currentBudget[0].currentId = budId
                            let newBudget = dBudget(id: budId, currentBudget: initial, currentSavings: 0.0, initialBudget: initial)
                            context.insert(newBudget)
                        }
                        
                        dismiss()
                    }
                    .disabled(initial == 0.0)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }

            }
        }
    }
    
}


struct ShowBudget: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    @Query(sort: \dBudget.id) var budgets: [dBudget]
    @Query(sort: \BudgetsManagement.lastId) var currentBudget: [BudgetsManagement]
    @Bindable var budget: dBudget
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                Text("How are your finances doing?")
                    .foregroundColor(.accentColor)
                    .font(.title)
                Text("Budget ID: \(budget.id)")
                    .font(.title2)
                    .opacity(0.4)
                Text("Your monthly budget is \(budget.initialBudget, specifier: "%.2f")PLN")
                    .font(.title2)
                    .opacity(0.6)
                    .opacity(0.5)
                Button("Set this budget as active")
                {
                    if (!currentBudget.isEmpty)
                    {
                        currentBudget[0].currentId = budget.id
                    }
                }
                .disabled(currentBudget[0].currentId == budget.id)
                
            }
            Spacer()
            HStack {
                VStack {
                    if (budget.currentBudget > 0) {
                        Text("\(budget.currentBudget, specifier: "%.2f")PLN")
                            .foregroundColor(.green)
                    } else {
                        Text("\(budget.currentBudget, specifier: "%.2f")PLN")
                            .foregroundColor(.red)
                    }
                    Text("How much money do you have")
                        .opacity(0.6)
                }
                VStack {
                    if (budget.currentSavings == 0) {
                        Text("\(budget.currentSavings, specifier: "%.2f")PLN")
                            .foregroundColor(.red)
                    } else {
                        Text("\(budget.currentSavings, specifier: "%.2f")PLN")
                            .foregroundColor(.green)
                    }
                    Text("How much money you've saved")
                        .opacity(0.6)
                    
                }
            } .offset(y:75)
        }
        
    }
}
