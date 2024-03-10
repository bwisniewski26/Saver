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
    
    init(name: String, date: Date, price: Double) {
        self.name = name
        self.date = date
        self.price = price
    }
}

@Model
class dBudget {
    var currentBudget: Double
    var initialBudget: Double
    var currentSavings: Double
    
    init(currentBudget: Double, currentSavings: Double, initialBudget: Double) {
        self.currentBudget = currentBudget
        self.currentSavings = currentSavings
        self.initialBudget = initialBudget
    }
    
}
