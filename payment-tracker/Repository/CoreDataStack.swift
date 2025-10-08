//
//  CoreDataStack.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 08/10/25.
//

import CoreData

protocol CoreDataStackProtocol {
    var container: NSPersistentContainer { get }
    var viewContext: NSManagedObjectContext { get }
    
    func newBackgroundContext() -> NSManagedObjectContext
    func saveContext(_ context: NSManagedObjectContext?) throws
}

final class CoreDataStack: CoreDataStackProtocol {
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext { container.viewContext }
    
    init(modelName: String = "PaymentTracker", appGroupID: String = "group.dev.venetikides.paymenttracker") {
        container = NSPersistentContainer(name: modelName)
        
        let storeURL: URL = {
            guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
                fatalError("App Group não encontrado: \(appGroupID)")
            }
            
            return containerURL.appendingPathComponent("\(modelName).sqlite")
        }()
        
        let description = NSPersistentStoreDescription(url: storeURL)
        description.type = NSSQLiteStoreType
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Erro ao carregar sore: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        let ctx = container.newBackgroundContext()
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return ctx
    }
    
    func saveContext(_ context: NSManagedObjectContext? = nil) throws {
        let ctx = context ?? viewContext
        if ctx.hasChanges {
            try ctx.save()
        }
    }
}
