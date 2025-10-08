//
//  Payment.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 07/10/25.
//

import UIKit

struct Payment {
    var name: String
    var cardName: String
    var value: Double
    var date: Date
}

extension Payment {
    static func mock() -> Self {
        Payment(name: "Compra exemplo", cardName: "Nubank", value: 10.00, date: Date())
    }
}
