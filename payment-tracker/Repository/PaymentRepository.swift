//
//  PaymentRepository.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 08/10/25.
//

import Foundation
import CoreData

struct PaymentRecord: Equatable {
    static func == (lhs: PaymentRecord, rhs: PaymentRecord) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: NSManagedObjectID
    let payment: Payment
}

final class PaymentRepository {
    private let stack: CoreDataStackProtocol
    
    init(stack: CoreDataStackProtocol) {
        self.stack = stack
    }
    
    @discardableResult
    func add(_ payment: Payment) throws -> PaymentRecord {
        let ctx = stack.viewContext
        let entity = PaymentEntity(context: ctx)
        entity.id = UUID()
        entity.name = payment.name
        entity.cardName = payment.cardName
        entity.value = payment.value
        entity.date = payment.date
        
        try stack.saveContext(ctx)
        
        return PaymentRecord(id: entity.objectID, payment: payment)
    }
    
    func fetchAll(sortedByDataDesc: Bool = true) throws -> [PaymentRecord] {
        let req: NSFetchRequest<PaymentEntity> = PaymentEntity.fetchRequest()
        if sortedByDataDesc {
            req.sortDescriptors = [NSSortDescriptor(key: #keyPath(PaymentEntity.date), ascending: false)]
        }
        let entities = try stack.viewContext.fetch(req)
        return entities.map {
            PaymentRecord(
                id: $0.objectID,
                payment: .init(
                    name: $0.name,
                    cardName: $0.cardName,
                    value: $0.value,
                    date: $0.date
                )
            )
        }
    }
    
    func update(id: NSManagedObjectID, with payment: Payment) throws {
        let ctx = stack.viewContext
        guard let entity = try? ctx.existingObject(with: id) as? PaymentEntity else { return }
        entity.name = payment.name
        entity.cardName = payment.cardName
        entity.value = payment.value
        entity.date = payment.date
        
        try stack.saveContext(ctx)
    }
    
    func delete(id: NSManagedObjectID) throws {
        let ctx = stack.viewContext
        if let obj = try?  ctx.existingObject(with: id) {
            ctx.delete(obj)
            try stack.saveContext(ctx)
        }
    }
    
    func totalAmount() throws -> Double {
        return try fetchAll().reduce(0.0) { $0 + $1.payment.value }
    }
}
