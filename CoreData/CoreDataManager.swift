//
//  CoreDataManager.swift
//  CoreData
//
//  Created by Apple on 12/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class CoreDataManager{
    public static var shared : CoreDataManager!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    public static func sharedInstance() -> CoreDataManager{
        if shared == nil{
            shared = CoreDataManager()
        }
        return shared
    }
    
    func getParentManagedContext() -> NSManagedObjectContext{
        let context = appDelegate.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    func getChildManagedContext() -> NSManagedObjectContext{
        let backgroundManagedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        backgroundManagedObjectContext.parent = self.getParentManagedContext()
        return backgroundManagedObjectContext
    }
    
    func getFetchRequestForEntity(entityName:String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: entityName)
        return fetchRequest as! NSFetchRequest<NSFetchRequestResult>
    }
    
    //write context
    func saveChildContext(childContext : NSManagedObjectContext, parentContext : NSManagedObjectContext){
        do {
            try childContext.save()
            parentContext.performAndWait {
                do {
                    try parentContext.save()
                } catch {
                    fatalError("Error in saving Data...")
                }
            }
        } catch {
            fatalError("Error in saving Data...")
        }
    }
    
    func saveParentContext(parentContext : NSManagedObjectContext) {
        do {
            try parentContext.save()
        } catch {
            fatalError("Error in saving Data...")
        }
    }
    
    //Fetch on child context
    func fetchAllRecordsForEntity(entityName : String,closure: @escaping ([NSManagedObject]) -> Void){
        var result : [NSManagedObject] = []
        let mainContext = CoreDataManager.sharedInstance().getParentManagedContext()
        mainContext.perform {
            do {
                result = try mainContext.fetch(self.getFetchRequestForEntity(entityName: entityName)) as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            DispatchQueue.main.async {
            closure(result)
            }
            return
        }
    }
    
    func fetchAllRecordsForEntityPredicate(entityName : String,predicate : NSPredicate,closure: @escaping ([NSManagedObject]) -> Void){
        var result : [NSManagedObject] = []
        let mainContext = CoreDataManager.sharedInstance().getParentManagedContext()
        mainContext.perform {
            do {
                let fetchRequest = self.getFetchRequestForEntity(entityName: entityName)
                fetchRequest.predicate = predicate
                result = try mainContext.fetch(fetchRequest) as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            DispatchQueue.main.async {
                closure(result)
            }
            return
        }
        
    }
    
    func deleteRecordForEntity(entityName : String,closure: @escaping () -> Void){
        let mainContext = CoreDataManager.sharedInstance().getParentManagedContext()
        mainContext.perform {
            do {
                let fetchRequest = self.getFetchRequestForEntity(entityName: entityName)
                let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try mainContext.execute(request)
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            DispatchQueue.main.async {
                closure()
            }
            return
        }
        
    }
    
    func deleteRecordPredicate(entityName : String,predicate : NSPredicate,closure: @escaping () -> Void){
        let mainContext = CoreDataManager.sharedInstance().getParentManagedContext()
        mainContext.perform {
            do {
                let fetchRequest = self.getFetchRequestForEntity(entityName: entityName)
                fetchRequest.predicate = predicate
                let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try mainContext.execute(request)
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            DispatchQueue.main.async {
                closure()
            }
            return
        }
        
    }
    
    func fetchSortedRecordsForEntity(entityName : String , sortAttribute : String , isAscending : Bool,closure: @escaping ([NSManagedObject]) -> Void){
        var result : [NSManagedObject] = []
        let mainContext = CoreDataManager.sharedInstance().getParentManagedContext()
        mainContext.perform {
            do {
                let fetchRequest = self.getFetchRequestForEntity(entityName: entityName)
                let sort = NSSortDescriptor(key: sortAttribute, ascending: isAscending)
                fetchRequest.sortDescriptors = [sort]
                result = try mainContext.fetch(fetchRequest) as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            DispatchQueue.main.async {
                closure(result)
            }
            return
        }
    }
    
    func fetchSortedRecordsForEntityPredicate(entityName : String ,predicate : NSPredicate, sortAttribute : String , isAscending : Bool,closure: @escaping ([NSManagedObject]) -> Void){
        var result : [NSManagedObject] = []
        let mainContext = CoreDataManager.sharedInstance().getParentManagedContext()
        mainContext.perform {
            do {
                let fetchRequest = self.getFetchRequestForEntity(entityName: entityName)
                fetchRequest.predicate = predicate
                let sort = NSSortDescriptor(key: sortAttribute, ascending: isAscending)
                fetchRequest.sortDescriptors = [sort]
                result = try mainContext.fetch(fetchRequest) as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            DispatchQueue.main.async {
                closure(result)
            }
            return
        }
    }
    
    
    func isExist(entityName : String,predicate : NSPredicate) -> Bool{
        var result : [NSManagedObject] = []
        let mainContext = CoreDataManager.sharedInstance().getParentManagedContext()
            do {
                let fetchRequest = self.getFetchRequestForEntity(entityName: entityName)
                fetchRequest.predicate = predicate
                result = try mainContext.fetch(fetchRequest) as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            return result.count > 0 ? true : false
        }
    
}
