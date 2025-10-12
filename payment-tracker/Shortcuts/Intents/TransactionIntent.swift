//
//  TransactionIntent.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 09/10/25.
//

import AppIntents
import CoreData
import WidgetKit
import os

struct TransactionIntent: AppIntent {
    static var title: LocalizedStringResource = "Adicionar nova transação"
    
    let logger = Logger(subsystem: "dev.pockly", category: "intent")

    static let supportedModes: IntentModes = [
        .background
    ]

    static var parameterSummary: some ParameterSummary {
        Summary("Adicionar nova transação")
    }

    @Parameter(title: "Valor", description: "Valor da transação")
    var amount: String?

    func perform() async throws -> some IntentResult {
        guard let amount else {
            return .result()
        }
        
        let newPayment = Payment(
            name: "Atalho",
            cardName: "Carteira",
            value: Self.parseCurrency(amount),
            date: Date()
        )

        let stack = await MainActor.run { CoreDataStack() }
        let repo = await MainActor.run { PaymentRepository(stack: stack) }

        do {

            let ctx = await MainActor.run { stack.newBackgroundContext() }

            try await ctx.perform {
                _ = try repo.add(newPayment)
            }

            let total = try await MainActor.run { try repo.totalAmountFOrCurrentWeek() }

            if let groupDefaults = UserDefaults(
                suiteName: "group.dev.venetikides.paymenttracker"
            ) {
                groupDefaults.set(total, forKey: "totalAmount")
            }

            await MainActor.run {
                WidgetCenter.shared.reloadAllTimelines()
            }

            return .result()
        } catch {
            logger.debug("Catched error: \(error.localizedDescription, privacy: .public)")
            return .result()
        }
    }
    
    private static func parseCurrency(_ text: String) -> Double {
        let brCurrency = NumberFormatter()
        brCurrency.locale = Locale(identifier: "pt_BR")
        brCurrency.numberStyle = .currency
        if let n = brCurrency.number(from: text) {
            return n.doubleValue
        }

        let brDecimal = NumberFormatter()
        brDecimal.locale = Locale(identifier: "pt_BR")
        brDecimal.numberStyle = .decimal
        if let n = brDecimal.number(from: text) {
            return n.doubleValue
        }

        let allowed = CharacterSet(charactersIn: "0123456789.,-")
        let scalars = text.unicodeScalars.filter { allowed.contains($0) }
        var s = String(String.UnicodeScalarView(scalars))

        if s.contains(",") {
            s = s.replacingOccurrences(of: ".", with: "")
            s = s.replacingOccurrences(of: ",", with: ".")
        } else {
            s = s.replacingOccurrences(of: ",", with: "")
        }

        return Double(s) ?? 0.0
    }
}
