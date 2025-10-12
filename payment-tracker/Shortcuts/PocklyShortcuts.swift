//
//  PocklyShortcuts.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 09/10/25.
//

import AppIntents

struct PocklyShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        
        AppShortcut(
            intent: TransactionIntent(),
            phrases: ["Adicionar transação \(.applicationName)"],
            shortTitle: "Transação",
            systemImageName: "dollarsign"
        )
    }
}
