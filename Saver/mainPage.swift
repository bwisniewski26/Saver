//
//  ContentView.swift
//  Saver
//
//  Created by Bartek Wiśniewski on 19/01/2024.
//

import SwiftUI
import SwiftData
import UIKit



var saving = Budget(maxBudget: 0, currentBudget: 0, currentSaving: 0, savingPercent: 0)
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
        ScrollView {
            VStack {
                Text("How are your finances doing?")
                    .foregroundColor(.accentColor)
                    .font(.title)
                
                Text("Your monthly budget is \(Double(saving.maxBudget)/100, specifier: "%.2f")PLN")
                    .font(.title2)
                    .opacity(0.6)
                
            }
            Spacer()
            HStack {
                VStack {
                    if (saving.currentBudget > 0) {
                        Text("\(Double(saving.currentBudget)/100, specifier: "%.2f")PLN")
                            .foregroundColor(.green)
                    } else {
                        Text("\(Double(saving.currentBudget)/100, specifier: "%.2f")PLN")
                            .foregroundColor(.red)
                    }
                    Text("How much money do you have")
                        .opacity(0.6)
                }
                VStack {
                    if (saving.currentSaving == 0) {
                        Text("\(Double(saving.currentSaving)/100, specifier: "%.2f")PLN")
                            .foregroundColor(.red)
                    } else {
                        Text("\(Double(saving.currentSaving)/100, specifier: "%.2f")PLN")
                            .foregroundColor(.green)
                    }
                    Text("How much money you've saved")
                        .opacity(0.6)
                    
                }
            } .offset(y:75)
        }
        .defaultScrollAnchor(.bottom)
    }
}

struct setBudget: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var input: String = ""
    @FocusState private var isFocused: Bool
    @State var possibleBudget: Int?
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Change your budget information")
                    .foregroundColor(.accentColor)
                    .font(.title)
                Text("Your monthly budget is \(Double(saving.maxBudget)/100, specifier: "%.2f")PLN")
                    .font(.title2)
                    .opacity(0.6)
            }
            Form {
                TextField("New budget", text: $input) {
                    
                }
                .ignoresSafeArea(.keyboard)

            }
            .frame(height:100)
            if input.count > 0 {
                Button("Save changes") {
                    if input.count > 0 {
                        possibleBudget = Int(input)
                        if possibleBudget != nil {
                            if let possibleBudget {
                                let cents = possibleBudget%100
                                var newBudget = possibleBudget*100 + cents
                                saving.changeMaxBudget(newBudget: newBudget)
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .font(.title3)
            } else {
                Button("Save changes") {
                    
                }
                .foregroundColor(Color.gray)
            }
            
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
                    VStack {
                        HStack {
                            Image(systemName: "creditcard")
                            Text("\(saving.purchases[i].name)")
                                .font(.title2)
                            .bold()
                            Spacer()
                            Text("\(Double(saving.purchases[i].cost)/100, specifier: "%.2f")PLN | ")
                                .opacity(0.6)
                                
                            Text("\(saving.purchases[i].dateString)")
                                .opacity(0.6)
                        }
                    }
                    // Text("\(saving.purchases[i].name), \(Double(saving.purchases[i].cost)/100, specifier: "%.2f")PLN, Dated at: \(saving.purchases[i].dateString)")
                    
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
                .ignoresSafeArea(.keyboard)

                TextField(text: $cost_input, prompt: Text("Enter purchase cost")) {
                }
                .ignoresSafeArea(.keyboard)
            }
            .frame(height:200)
            
            Button("Add purchase") {
                if new_name.count > 0 && cost_input.count > 0 {
                    new_purchase.name = new_name
                    new_cost = Int(cost_input)
                    if new_cost != nil {
                        if let new_cost {
                            let cents = new_cost % 100
                            new_purchase.cost = new_cost*100 + cents
                        }
                    }
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
