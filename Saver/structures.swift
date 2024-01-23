//
//  structures.swift
//  Saver
//
//  Created by Bartek Wiśniewski on 21/01/2024.
//


import Foundation
import SwiftData
import SwiftUI



struct purchaseStruct {
    
    var cost: Int
    var name, dateString: String
    
    init(cost: Int, name: String, dateString: String) {
        self.cost = cost
        self.name = name
        self.dateString = dateString
    }
    
    init() {
        self.cost = 0
        self.name = ""
        self.dateString = ""
    }
}

class Budget {
    var maxBudget: Int
    var currentBudget: Int
    var currentSaving: Int
    var savingPercent: Int
    var purchases: [purchaseStruct] = []
    
    init(maxBudget: Int, currentBudget: Int, currentSaving: Int, savingPercent: Int) {
        self.maxBudget = maxBudget
        self.currentBudget = currentBudget
        self.currentSaving = currentSaving
        self.savingPercent = savingPercent
    }
    
    func changeMaxBudget(newBudget: Int) {
        maxBudget = newBudget
        updateCurrentBudget()
    }
    
    func addSaving(by amount: Int) {
        currentSaving += amount
    }
    
    func newPurchase(purchase_amount: Int, name: String) {
        currentBudget -= purchase_amount
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let localizedDate = dateFormatter.string(from: Date())
        
        let purchase = purchaseStruct(cost: purchase_amount, name: name, dateString: localizedDate)
        purchases.append(purchase)
        updateCurrentBudget()
    }
    
    func addPurchase(new_purchase: purchaseStruct) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let localizedDate = dateFormatter.string(from: Date())
        var formattedPurchase = new_purchase
        formattedPurchase.dateString = localizedDate
        print("\(formattedPurchase.name)")
        purchases.append(formattedPurchase)
        updateCurrentBudget()
    }
    
    func updateCurrentBudget() {
        currentBudget = maxBudget
        for purchase in purchases {
            currentBudget -= purchase.cost
        }
    }
    
    
}
