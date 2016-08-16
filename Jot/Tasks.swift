//
//  TaskDetails.swift
//  Jot
//
//  Created by Greg on 8/3/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import Foundation
import CoreData

@objc(Tasks)
class Tasks: NSManagedObject {
    
    func getDate() -> String{
        if taskDateTime != nil {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            let date = formatter.stringFromDate(taskDateTime!)
            return date
        }
        return "n/a"
    }
    
    func getTime() -> String {
        if taskDateTime != nil {
            let formatter = NSDateFormatter()
            formatter.timeStyle = .ShortStyle
            let time = formatter.stringFromDate(taskDateTime!)
            return time
        }
        return "n/a"
    }
    
    func getRemDate() -> String{
        if reminderDateTime != nil {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            let date = formatter.stringFromDate(reminderDateTime!)
            return date
        }
        return "n/a"
    }
    
    func getRemTime() -> String {
        if reminderDateTime != nil {
            let formatter = NSDateFormatter()
            formatter.timeStyle = .ShortStyle
            let time = formatter.stringFromDate(reminderDateTime!)
            return time
        }
        return "n/a"
    }

}
