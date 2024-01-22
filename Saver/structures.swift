//
//  saving.swift
//  Saver
//
//  Created by Bartek Wiśniewski on 21/01/2024.
//

import Foundation



struct purchaseStruct {
    var cost: Float
    var name, dateString: String
    
    init(cost: Float, name: String, dateString: String) {
        self.cost = cost
        self.name = name
        self.dateString = dateString
    }
    
}

class Budget {
    var maxBudget: Float
    var currentBudget: Float
    var currentSaving: Float
    var savingPercent: Float
    var purchases = [purchaseStruct]()
    
    init(maxBudget: Float, currentBudget: Float, currentSaving: Float, savingPercent: Float) {
        self.maxBudget = maxBudget
        self.currentBudget = currentBudget
        self.currentSaving = currentSaving
        self.savingPercent = savingPercent
    }
    
    func changeMaxBudget(newBudget: Float) {
        maxBudget = newBudget
    }
    
    func addSaving(by amount: Float) {
        currentSaving += amount
    }
    
    func newPurchase(purchase_amount: Float, name: String) {
        currentBudget -= purchase_amount
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let localizedDate = dateFormatter.string(from: Date())
        let purchase = purchaseStruct(cost: purchase_amount, name: name, dateString: localizedDate)
        purchases.append(purchase)
    }
}

