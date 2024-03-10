//
//  ContentView.swift
//  Saver
//
//  Created by Bartek Wiśniewski on 19/01/2024.
//

import SwiftUI
import SwiftData
import UIKit


struct mainPage: View {
    @Environment(\.modelContext) var context
    @Query(sort: \dBudget.currentBudget) var budget: [dBudget]
    
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    NavigationLink(destination: info()) {
                        HStack {
                            Image(systemName: "creditcard")
                                .font(.title2)
                            Text("Budget and savings")
                        }
                    }
                    NavigationLink(destination: showPurchases()) {
                        HStack {
                            Image(systemName: "cart")
                                .font(.title2)
                            Text("List purchases")
                        }
                    }
                    NavigationLink(destination: settings()) {
                        HStack {
                            Image(systemName: "gear")
                                .font(.title2)
                            Text("Settings")
                        }
                    }
                    
                }
                .navigationBarTitle("Saver")
            }
            .edgesIgnoringSafeArea(.all)
        }
        
            
            
    }
}




#Preview {
    mainPage()
}
