//
//  showPurchases.swift
//  Saver
//
//  Created by Bartek Wiśniewski on 09/03/2024.
//

import SwiftUI
import SwiftData

struct purchases: View {
    @Environment(\.modelContext) var context
    @State private var isShowingPurchaseSheet = false
    @State private var isShowingUpdatePurchaseSheet = false
    @Query(sort: \Purchase.date) var purchases: [Purchase]
    @Query() var budgets: [dBudget]
    @Query() var budgetsInfo: [BudgetsManagement]
    @State private var purchaseToEdit: Purchase?
    
    var body: some View {
        VStack {
            if (!purchases.isEmpty)
            {
                List {
                    if (!budgets.isEmpty && !budgetsInfo.isEmpty)
                    {
                        ForEach(purchases) { purchase in
                            if (budgets[budgetsInfo[0].currentId].purchases.contains(purchase) || purchase.budgetId == nil)
                            {
                                purchaseInfo(purchase: purchase)
                                    .contextMenu{
                                        Button("Update purchase")
                                        {
                                            purchaseToEdit = purchase
                                            isShowingUpdatePurchaseSheet = true
                                        }
                                        Button("Delete purchase")
                                        {
                                            budgets[budgetsInfo[0].currentId].currentSavings -= purchase.saving ?? 0.0
                                            budgets[budgetsInfo[0].currentId].currentBudget += purchase.price
                                            context.delete(purchase)
                                            budgets[budgetsInfo[0].currentId].purchases.removeAll { purchaseToRemove in
                                              return purchaseToRemove == purchase
                                            }
                                        }
                                        
                                    }
                            }
                        }
                    } else
                    {
                        ForEach(purchases) { purchase in
                            purchaseInfo(purchase: purchase)
                                .contextMenu{
                                    Button("Update purchase")
                                    {
                                        purchaseToEdit = purchase
                                        isShowingUpdatePurchaseSheet = true
                                    }
                                    Button("Delete purchase")
                                    {
                                        context.delete(purchase)
                                    }
                                }
                        }
                    }
                }
            }
            else {
                ContentUnavailableView(label: {
                    Label("Purchase list empty.", systemImage: "doc.questionmark.fill")
                }, description: {
                    Text("Add your purchases to see your list.")
                }, actions: {
                    Button("Add purchase") {
                        isShowingPurchaseSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                )
            }
        }
        .sheet(isPresented: $isShowingPurchaseSheet) { AddPurchase() }
        .sheet(item: $purchaseToEdit) { purchase in
            UpdatePurchase(purchase: purchase)
        }
        .navigationTitle("Purchases list")
        .toolbar {
                Button("Add purchase", systemImage: "cart.badge.plus") {
                    isShowingPurchaseSheet = true
                }
        }
                
    }
}

struct purchaseInfo: View {
    let purchase: Purchase
    var body: some View {
        HStack{
            Image(systemName: "creditcard")
            Text("\(purchase.name)")
                .font(.title2)
                .bold()
            Spacer()
            Text("Price: \(purchase.price, format: .currency(code:"PLN"))")
                .opacity(0.6)
            Text("Savings: \(purchase.saving ?? 0.0, format: .currency(code: "PLN"))")
                .opacity(0.6)
            Text("Date: \(purchase.date, format: .dateTime.month(.abbreviated).day())")
                .opacity(0.6)
            if (purchase.budgetId != nil)
            {
                Text("Budget ID: \(purchase.budgetId!)")
            }
            }
    }
}

struct UpdatePurchase: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    @State var option: Int = 0
    @Bindable var purchase: Purchase
    
    var body: some View {
        NavigationStack {
            Form {
                
                TextField("Purchase name", text: $purchase.name)
                DatePicker("Purchase date: ", selection: $purchase.date, displayedComponents: .date)
                TextField("Price", value: $purchase.price, format: .currency(code: "PLN"))
                Picker("Saving option", selection: $option) {
                    Text("0 PLN").tag(0)
                    if (1 - purchase.price.truncatingRemainder(dividingBy: 1.0) != 1)
                    {
                        Text("\(1 - purchase.price.truncatingRemainder(dividingBy: 1.0), specifier: "%.2f") PLN").tag(1)
                    }
                    if (5 - purchase.price.truncatingRemainder(dividingBy: 5.0) != 1 - purchase.price.truncatingRemainder(dividingBy: 1.0))
                    {
                        Text("\(5 - purchase.price.truncatingRemainder(dividingBy: 5.0), specifier: "%.2f") PLN").tag(5)
                    }
                    if (5 - purchase.price.truncatingRemainder(dividingBy: 5.0) != 10 - purchase.price.truncatingRemainder(dividingBy: 10.0))
                    {
                        Text("\(10 - purchase.price.truncatingRemainder(dividingBy: 10.0), specifier: "%.2f") PLN").tag(10)
                    }
                    if (purchase.price > 100)
                    {
                        if (10 - purchase.price.truncatingRemainder(dividingBy: 10.0) != 100 - purchase.price.truncatingRemainder(dividingBy: 100.0))
                        {
                            Text("\(100 - purchase.price.truncatingRemainder(dividingBy: 100.0), specifier: "%.2f") PLN").tag(100)
                        }
                    }
                    if (purchase.price > 1000 && 100 - purchase.price.truncatingRemainder(dividingBy: 100.0) != 1000 - purchase.price.truncatingRemainder(dividingBy: 1000.0))
                    {
                        Text("\(1000 - purchase.price.truncatingRemainder(dividingBy: 1000.0), specifier: "%.2f" ) PLN").tag(1000)
                    }
                }
                
            }
            .navigationTitle("Update purchase")
            .toolbar {
                
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Done") {
                        if (option != 0)
                        {
                            purchase.saving = Double(option) - purchase.price.truncatingRemainder(dividingBy: Double(option))
                        }
                        else
                        {
                            purchase.saving = 0.0
                        }
                        dismiss()
                    }
                    .disabled(purchase.price == 0 || purchase.name == "")
                }
            }
        }
        .frame(width:350, height: 160)
        .fixedSize()
    }
    
}


struct AddPurchase: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    @Query(sort: \dBudget.id) var budget: [dBudget]
    @Query(sort: \BudgetsManagement.lastId) var budgetManagement: [BudgetsManagement]
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var price: Double = 0
    @State private var option: Int = 0
    @State private var assignToBudget: Bool = false
    var body: some View {
        NavigationStack {
            Form {
                TextField("Purchase name", text: $name)
                DatePicker("Purchase date: ", selection: $date, displayedComponents: .date)
                TextField("Price", value: $price, format: .currency(code: "PLN"))
                Picker("Saving option", selection: $option) {
                    Text("0 PLN").tag(0)
                    if (1 - price.truncatingRemainder(dividingBy: 1.0) != 1)
                    {
                        Text("\(1 - price.truncatingRemainder(dividingBy: 1.0), specifier: "%.2f") PLN").tag(1)
                    }
                    if (5 - price.truncatingRemainder(dividingBy: 5.0) != 1 - price.truncatingRemainder(dividingBy: 1.0))
                    {
                        Text("\(5 - price.truncatingRemainder(dividingBy: 5.0), specifier: "%.2f") PLN").tag(5)
                    }
                    if (5 - price.truncatingRemainder(dividingBy: 5.0) != 10 - price.truncatingRemainder(dividingBy: 10.0))
                    {
                        Text("\(10 - price.truncatingRemainder(dividingBy: 10.0), specifier: "%.2f") PLN").tag(10)
                    }
                    if (price > 100)
                    {
                        if (10 - price.truncatingRemainder(dividingBy: 10.0) != 100 - price.truncatingRemainder(dividingBy: 100.0))
                        {
                            Text("\(100 - price.truncatingRemainder(dividingBy: 100.0), specifier: "%.2f") PLN").tag(100)
                        }
                    }
                    if (price > 1000 && 100 - price.truncatingRemainder(dividingBy: 100.0) != 1000 - price.truncatingRemainder(dividingBy: 1000.0))
                    {
                        Text("\(1000 - price.truncatingRemainder(dividingBy: 1000.0), specifier: "%.2f" ) PLN").tag(1000)
                    }
                }
                Toggle(isOn:$assignToBudget)
                {
                    Text("Assign to budget?")
                }
                .toggleStyle(.checkbox)
                
            }
            .navigationTitle("Add purchase")
            .toolbar {

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                            if (!budget.isEmpty && !budgetManagement.isEmpty && assignToBudget) {
                                
                                var saving: Double
                                if (option != 0)
                                {
                                    saving = Double(option) - price.truncatingRemainder(dividingBy: Double(option))
                                    budget[budgetManagement[0].currentId].currentSavings += Double(option) - price.truncatingRemainder(dividingBy: Double(option))
                                }
                                else
                                {
                                    saving = 0.0
                                }
                                budget[budgetManagement[0].currentId].currentBudget -= price
                                let purchase = Purchase(name: name, date: date, price: price, saving: saving)
                                purchase.budgetId = budgetManagement[0].currentId
                                budget[budgetManagement[0].currentId].purchases.append(purchase)
                                context.insert(purchase)
                                dismiss()
                            }
                            else
                            {
                                var saving: Double = 0.0
                                if (option != 0)
                                {
                                    saving = Double(option) - price.truncatingRemainder(dividingBy: Double(option))
                                }
                                else {
                                    saving = 0.0
                                }
                                let purchase = Purchase(name: name, date: date, price: price, saving: saving)
                                context.insert(purchase)
                                dismiss()
                            }
                    }
                    .disabled(price == 0 || name == "")
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
        .frame(width:350, height: 160)
        .fixedSize()
    }
    
}
