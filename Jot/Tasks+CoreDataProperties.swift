//
//  Tasks+CoreDataProperties.swift
//  Jot
//
//  Created by Greg on 8/11/16.
//  Copyright © 2016 Greg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tasks {

    @NSManaged var categoryName: String?
    @NSManaged var notes: String?
    @NSManaged var reminderDateTime: NSDate?
    @NSManaged var taskDateTime: NSDate?
    @NSManaged var taskName: String?

}
