//
//  ContentView.swift
//  Saver
//
//  Created by Bartek Wiśniewski on 19/01/2024.
//

import SwiftUI


var saving = Budget(maxBudget: 500, currentBudget: 250, currentSaving: 0, savingPercent: 0.0)
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
            
            Text("Your monthly budget is \(saving.maxBudget, specifier: "%.2f")PLN")
                .font(.title2)
        } .offset(y:-300)
        HStack {
            VStack {
                Text("\(saving.currentBudget, specifier: "%.2f")PLN")
                    .foregroundColor(.green)
                Text("How much money do you have")
            }
            VStack {
                if (saving.currentSaving == 0) {
                    Text("\(saving.currentSaving, specifier: "%.2f")PLN")
                        .foregroundColor(.red)
                } else {
                    Text("\(saving.currentSaving, specifier: "%.2f")PLN")
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
    @State var possibleBudget: Float?
    
    var body: some View {
        VStack {
            Text("Change your budget information")
                .foregroundColor(.accentColor)
                .font(.title)
            Text("Your monthly budget is \(saving.maxBudget, specifier: "%.2f")PLN")
                .font(.title2)
        }
        .offset(y:-300)
        TextField(
        "New budget",
        text: $input
        )
        .focused($isFocused)
        .onSubmit {
            
            possibleBudget = Float(input)
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
        .offset(y:-280)
        Text("")
                .foregroundColor(isFocused ? .red : .blue)
        
    }
}

#Preview {
    mainPage()
}
