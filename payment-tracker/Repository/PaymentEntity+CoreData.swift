//
//  PaymentEntity+CoreData.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 08/10/25.
//

import CoreData

@objc(PaymentEntity)
final class PaymentEntity: NSManagedObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<PaymentEntity> {
        NSFetchRequest<PaymentEntity>(entityName: "PaymentEntity")
    }
}

extension PaymentEntity {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var cardName: String
    @NSManaged var value: Double
    @NSManaged var date: Date
}
