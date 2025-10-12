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
        
        guard let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            fatalError("App Group not found: \(appGroupID)")
        }
        
        let storeURL = groupURL.appendingPathComponent("\(modelName).sqlite")
        
        let description = NSPersistentStoreDescription(url: storeURL)
        description.type = NSSQLiteStoreType
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError?{
                fatalError("Erro ao carregar sore: \(error), \(error.userInfo)")
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
