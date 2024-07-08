//
//  Objects.swift
//  Saver
//
//  Created by Bartek Wiśniewski on 09/03/2024.
//

import Foundation
import SwiftData


@Model
class Purchase {
    var name: String
    var date: Date
    var price: Double
    var saving: Double?
    var budgetId: Int? = nil
    
    init(name: String, date: Date, price: Double, saving: Double?) {
        self.name = name
        self.date = date
        self.price = price
        self.saving = saving ?? 0.0
    }
}

@Model
class dBudget {
    var id: Int
    var currentBudget: Double
    var initialBudget: Double
    var currentSavings: Double
    var purchases: [Purchase]
    
    init(id: Int, currentBudget: Double, currentSavings: Double, initialBudget: Double) {
        self.id = id
        self.currentBudget = currentBudget
        self.currentSavings = currentSavings
        self.initialBudget = initialBudget
        self.purchases = []
    }
    
}

@Model
class BudgetsManagement {
    var lastId: Int
    var currentId: Int
    
    init(lastId: Int)
    {
        self.lastId = lastId
        self.currentId = lastId
    }
    
    init() {
        self.currentId = 0
        self.lastId = 0
    }
}
