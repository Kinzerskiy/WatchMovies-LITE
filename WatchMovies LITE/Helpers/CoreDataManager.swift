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
    
    var favoritesContainer: NSPersistentContainer
    var datesContainer: NSPersistentContainer
    
    var favoritesContext: NSManagedObjectContext {
        return favoritesContainer.viewContext
    }
    
    var datesContext: NSManagedObjectContext {
        return datesContainer.viewContext
    }
    
    init() {
        self.favoritesContainer = (UIApplication.shared.delegate as! AppDelegate).favoritesContainer
        self.datesContainer = (UIApplication.shared.delegate as! AppDelegate).datesContainer
    }
    
    func saveContext(context: NSManagedObjectContext) {
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
