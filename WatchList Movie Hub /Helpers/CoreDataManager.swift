//
//  CoreDataManager.swift
//  test_movieList
//
//  Created by User on 28.04.2024.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static var shared = CoreDataManager()
    
    var persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
         return persistentContainer.viewContext
     }
    
    init() {
        self.persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
