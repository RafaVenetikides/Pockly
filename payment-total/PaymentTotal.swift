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
       
        let now = Date()
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)),
              let nextMonday = calendar.date(byAdding: .day, value: 7, to: startOfWeek) else {
            return
        }
        
        let entry = PaymentEntry(date: now, totalAmount: total)
        
        
        let timeline = Timeline(entries: [entry], policy: .after(nextMonday))
        completion(timeline)
    }
}

struct PaymentEntry: TimelineEntry {
    let date: Date
    let totalAmount: Double
}

struct PaymentTotalEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            smallWidgetView
        default:
            mediumWidgetView
        }
    }
    
    private var smallWidgetView: some View {
        VStack(spacing: 4) {
            Spacer()
            
            Text("R$ \(entry.totalAmount, specifier: "%.2f")")
                .font(.title3)
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            Spacer()
            
            Text("Semana")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(weekLabel(format: "dd/MM"))
                .font(.system(size: 15))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .multilineTextAlignment(.center)
    }
    
    private var mediumWidgetView: some View {
        VStack {
            Spacer()
            
            Text("Gastos da semana")
            Text("R$ \(entry.totalAmount, specifier: "%.2f")")
                .font(.title)
                .bold()
            
            Spacer()
            
            Text(weekLabel())
        }
        .padding()
    }
    
    func weekLabel(format: String = "dd MMM") -> String {
        let calendar = Calendar.current
        let now = Date()
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)),
              let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else {
            return "Unknown"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek))"
    }
}

struct PaymentTotal: Widget {
    let kind: String = "payment_total"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PaymentTotalEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                PaymentTotalEntryView(entry: entry)
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
    PaymentTotal()
} timeline: {
    PaymentEntry(date: .now, totalAmount: 15.0)
    PaymentEntry(date: .now, totalAmount: 30.0)
}
