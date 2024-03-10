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
    
    @State private var purchaseToEdit: Purchase?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(purchases) { purchase in
                    purchaseInfo(purchase: purchase)
                        .onTapGesture {
                            purchaseToEdit = purchase
                        }
                }
                .onDelete { purchaseSet in
                    for purchase in purchaseSet {
                        context.delete(purchases[purchase])
                    }
                }
            }
            .navigationTitle("Purchase list")
            .navigationBarTitleDisplayMode(.large)
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
    @Query(sort: \dBudget.currentBudget) var budget: [dBudget]
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var price: Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                
                TextField("Purchase name", text: $name)
                DatePicker("Purchase date: ", selection: $date, displayedComponents: .date)
                TextField("Price", value: $price, format: .currency(code: "PLN"))
                    .keyboardType(.decimalPad)
                
            }
            .navigationTitle("Add purchase")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        let purchase = Purchase(name: name, date: date, price: price)
                        if !budget.isEmpty {
                            budget[0].currentBudget = budget[0].currentBudget - price
                        }
                        context.insert(purchase)
                        
                        dismiss()
                    }
                }
            }
        }
    }
    
}

#Preview {
    showPurchases()
}
