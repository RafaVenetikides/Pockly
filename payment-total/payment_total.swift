//
//  payment_total.swift
//  payment-total
//
//  Created by Rafael Venetikides on 07/10/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> PaymentEntry {
        PaymentEntry(date: Date(), totalAmount: 0.0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (PaymentEntry) -> Void) {
        let entry = PaymentEntry(date: Date(), totalAmount: 123.45)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<PaymentEntry>) -> Void) {
        let defaults = UserDefaults(suiteName: "group.dev.venetikides.paymenttracker")
        let total = defaults?.double(forKey: "totalAmount") ?? 0.0
        
        let entry = PaymentEntry(date: Date(), totalAmount: total)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct PaymentEntry: TimelineEntry {
    let date: Date
    let totalAmount: Double
}

struct payment_totalEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Weekly Spending")
            Text("R$ \(entry.totalAmount, specifier: "%.2f")")
                .font(.title)
                .bold()
        }
        .padding()
    }
}

struct payment_total: Widget {
    let kind: String = "payment_total"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                payment_totalEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                payment_totalEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Weekly Spending")
        .description("Shows your total card expenses this week.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    payment_total()
} timeline: {
    PaymentEntry(date: .now, totalAmount: 15.0)
    PaymentEntry(date: .now, totalAmount: 30.0)
}
