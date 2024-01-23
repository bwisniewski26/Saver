//
//  ContentView.swift
//  Saver
//
//  Created by Bartek Wiśniewski on 19/01/2024.
//

import SwiftUI
import SwiftData
import UIKit



var saving = Budget(maxBudget: 500, currentBudget: 250, currentSaving: 0, savingPercent: 0)
struct mainPage: View {
    var body: some View {
        VStack {
            NavigationSplitView {
                List {
                    NavigationLink(destination: info()) {
                        Text("Budget and savings")
                    }
                    NavigationLink(destination: setBudget()) {
                        Text("Manage your budget")
                    }
                    NavigationLink(destination: showPurchases()) {
                        Text("List purchases")
                    }
                    NavigationLink(destination: add()) {
                        Text("Add purchase")
                    }
                    
                }
                .navigationBarTitle("Saver")
                
            } detail: {
                Text("Choose option")
            }
            .edgesIgnoringSafeArea(.all)
        }
        
            
            
    }
}

struct info: View {
    var body: some View {
        VStack {
            Text("How are your finances doing?")
                .foregroundColor(.accentColor)
                .font(.title)
            
            Text("Your monthly budget is \(saving.maxBudget)PLN")
                .font(.title2)
        } .offset(y:-300)
        HStack {
            VStack {
                if (saving.currentBudget > 0) {
                    Text("\(saving.currentBudget)PLN")
                        .foregroundColor(.green)
                } else {
                    Text("\(saving.currentBudget)PLN")
                        .foregroundColor(.red)
                }
                Text("How much money do you have")
            }
            VStack {
                if (saving.currentSaving == 0) {
                    Text("\(saving.currentSaving)PLN")
                        .foregroundColor(.red)
                } else {
                    Text("\(saving.currentSaving)PLN")
                        .foregroundColor(.green)
                }
                Text("How much money you've saved")
                
            }
        }
        .offset(y: -200)
    }
}

struct setBudget: View {
    @State private var input: String = ""
    @FocusState private var isFocused: Bool
    @State var possibleBudget: Int?
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Change your budget information")
                    .foregroundColor(.accentColor)
                    .font(.title)
                Text("Your monthly budget is \(saving.maxBudget)PLN")
                    .font(.title2)
            }
            TextField(
                "New budget",
                text: $input
            )
            .focused($isFocused)
            .onSubmit {
                
                possibleBudget = Int(input)
                if possibleBudget != nil {
                    if let possibleBudget {
                        saving.changeMaxBudget(newBudget: possibleBudget)
                        
                    }
                }
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .onAppear {
                isFocused = false
            }
            Text("")
                .foregroundColor(isFocused ? .red : .blue)
            
        }
        .defaultScrollAnchor(.bottom)
    }
}

struct showPurchases: View {
    
    var body: some View {
        Text("Purchase list")
            .foregroundColor(.accentColor)
            .font(.title)
        ScrollView {
            if saving.purchases.isEmpty {
                Text("Your purchase list is empty!")
            } else {
                let count = saving.purchases.count
                ForEach(0..<count, id: \.self) {i in
                    Text("\(saving.purchases[i].name), \(saving.purchases[i].cost)PLN, Dated at: \(saving.purchases[i].dateString)")
                    
                }
            }
        }
    }
}

/*
 var cost: Float
 var name, dateString: String
*/

struct add: View {
    @Environment(\.presentationMode) var presentationMode
    @State var cost_input: String = ""
    @State var new_name: String = ""
    @State var date: String = ""
    @State var new_cost: Int? = 0
    @State var new_purchase = purchaseStruct()
    @FocusState var isFocused: Bool
    var body: some View {
        ScrollView {
            VStack {
                Text("Add new purchase")
                    .font(.title)
            }
            Text("Remember to press Return in all fields!")
            Form {
                TextField(text: $new_name, prompt: Text("Enter purchase name")) {
                    
                }
                .focused($isFocused)
                .onSubmit {
                    new_purchase.name = new_name
                }
                TextField(text: $cost_input, prompt: Text("Enter purchase cost")) {
                }
                .onSubmit {
                    
                    new_cost = Int(cost_input)
                    if new_cost != nil {
                        if let new_cost {
                            new_purchase.cost = new_cost
                        }
                    }
                }
                .ignoresSafeArea(.keyboard)
            }
            .frame(height:200)
            
            Button("Add purchase") {
                if new_purchase.name.count > 0 {
                    if new_purchase.cost > 0 {
                            saving.addPurchase(new_purchase: new_purchase)
                        self.presentationMode.wrappedValue.dismiss()
                            
                    }
                }
                
            }.buttonStyle(.borderedProminent)
                .font(.title3)
        }
        .defaultScrollAnchor(.bottom)
    }
}

#Preview {
    mainPage()
}
