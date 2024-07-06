//
//  showPurchases.swift
//  Saver
//
//  Created by Bartek Wiśniewski on 09/03/2024.
//

import SwiftUI
import SwiftData

struct showPurchases: View {
    @Environment(\.modelContext) var context
    @State private var isShowingPurchaseSheet = false
    @State private var isShowingUpdatePurchaseSheet = false
    @Query(sort: \Purchase.date) var purchases: [Purchase]
    @Query() var budgets: [dBudget]
    @Query() var budgetsInfo: [BudgetsManagement]
    
    @State private var purchaseToEdit: Purchase?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(purchases) { purchase in
                    if (!budgetsInfo.isEmpty && !budgets.isEmpty)
                    {
                        if (budgetsInfo[0].currentId == purchase.budgetId)
                        {
                            purchaseInfo(purchase: purchase)
                                .onTapGesture {
                                    purchaseToEdit = purchase
                                }
                        }
                    }
                    else{
                        purchaseInfo(purchase: purchase)
                            .onTapGesture {
                                purchaseToEdit = purchase
                            }
                    }
                }
                .onDelete { purchaseSet in
                    for purchase in purchaseSet {
                        context.delete(purchases[purchase])
                    }
                }
            }
            .overlay {
                if purchases.isEmpty {
                    ContentUnavailableView(label: {
                        Label("Purchase list empty.", systemImage: "doc.questionmark.fill")
                    }, description: {
                        Text("Add your purchases to see your list.")
                    }, actions: {
                        Button("Add purchase") {
                            isShowingPurchaseSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                    })
                    .offset(y: -60)
                }
            }
            .sheet(isPresented: $isShowingPurchaseSheet) { AddPurchase() }
            .sheet(item: $purchaseToEdit) { purchase in
                UpdatePurchase(purchase: purchase)
            }
            .toolbar {
                if !purchases.isEmpty {
                    Button("Add purchase", systemImage: "cart.badge.plus") {
                        isShowingPurchaseSheet = true
                    }
                }
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
            Text("\(purchase.price, format: .currency(code:"PLN"))")
                .opacity(0.6)
            
            Text("\(purchase.date, format: .dateTime.month(.abbreviated).day())")
                .opacity(0.6)
            }
    }
}

struct UpdatePurchase: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    
    @Bindable var purchase: Purchase
    
    var body: some View {
        NavigationStack {
            Form {
                
                TextField("Purchase name", text: $purchase.name)
                DatePicker("Purchase date: ", selection: $purchase.date, displayedComponents: .date)
                TextField("Price", value: $purchase.price, format: .currency(code: "PLN"))
                    .keyboardType(.decimalPad)
                
            }
            .navigationTitle("Update purchase")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
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
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Purchase name", text: $name)
                DatePicker("Purchase date: ", selection: $date, displayedComponents: .date)
                TextField("Price", value: $price, format: .currency(code: "PLN"))
                    .keyboardType(.decimalPad)
                Picker("Saving option", selection: $option) {
                    Text("0 PLN").tag(0)
                    Text("\(1 - price.truncatingRemainder(dividingBy: 1.0), specifier: "%.2f") PLN").tag(1)
                    Text("\(5 - price.truncatingRemainder(dividingBy: 5.0), specifier: "%.2f") PLN").tag(5)
                    Text("\(10 - price.truncatingRemainder(dividingBy: 10.0), specifier: "%.2f") PLN").tag(10)
                    Text("\(100 - price.truncatingRemainder(dividingBy: 100.0), specifier: "%.2f") PLN").tag(100)
                    Text("\(1000 - price.truncatingRemainder(dividingBy: 1000.0), specifier: "%.2f" ) PLN").tag(1000)
                }
                
            }
            .navigationTitle("Add purchase")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                            if (!budget.isEmpty && !budgetManagement.isEmpty) {
                                budget[budgetManagement[0].currentId].currentSavings += Double(option) - price.truncatingRemainder(dividingBy: Double(option))
                                price += Double(option) - price.truncatingRemainder(dividingBy: Double(option))
                                budget[budgetManagement[0].currentId].currentBudget -= price
                                let purchase = Purchase(name: name, date: date, price: price, budgetId: budgetManagement[0].currentId)
                                context.insert(purchase)
                                dismiss()
                            }
                            else
                            {
                                let purchase = Purchase(name: name, date: date, price: price, budgetId: 0)
                                context.insert(purchase)
                                dismiss()
                            }
                    }
                    .disabled(price == 0 || name == "")
                }
            }
        }
    }
    
}

#Preview {
    showPurchases()
}
