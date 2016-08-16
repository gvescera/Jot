//
//  vcTaskDetails.swift
//  Jot
//
//  Created by Greg on 7/27/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import CoreData

class vcTaskDetails: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var txtTask: UITextField!
    @IBOutlet weak var txtNotes: UITextView!
    @IBOutlet weak var dpDate: UIDatePicker!
    @IBOutlet weak var dpReminder: UIDatePicker!
    @IBOutlet weak var btnSave: UIButton!
    
    // MARK: - Variables
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    var taskID: NSManagedObjectID!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let task = appDel.dataController.managedObjectContext.objectWithID(taskID) as! Tasks
        txtTask.text = task.taskName
        txtNotes.text = task.notes
        if task.taskDateTime != nil {
            dpDate.date = task.taskDateTime!
        }
        if task.reminderDateTime != nil {
            dpReminder.date = task.reminderDateTime!
        }
        btnSave.enabled = false
        txtNotes.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textViewDidChange(textView: UITextView) {
        changeSaveState(self)
    }
    
    // MARK: - Custom Functions
    @IBAction func saveTaskDetails() {
        let task = appDel.dataController.managedObjectContext.objectWithID(taskID) as! Tasks
        task.taskName = txtTask.text
        task.notes = txtNotes.text
        task.taskDateTime = dpDate.date
        task.reminderDateTime = dpReminder.date
        
        do {
            try appDel.dataController.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        btnSave.enabled = false
        
    }
    
    
    @IBAction func changeSaveState(sender: AnyObject) {
        if txtTask.text != "" {
            btnSave.enabled = true
        }
        else {
            btnSave.enabled = false
        }
        print("was rolled")
    }
    

}
