//
//  vcNewTask.swift
//  Jot
//
//  Created by Greg on 7/27/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import CoreData

class vcNewTask: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var txtTask: UITextField!
    @IBOutlet weak var txtNotes: UITextView!
    @IBOutlet weak var dpDate: UIDatePicker!
    @IBOutlet weak var dpReminder: UIDatePicker!
    @IBOutlet weak var btnSave: UIButton!
    
    // MARK: - Variables
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    var categoryName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.enabled = false
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
    @IBAction func saveTask() {
        self.dismissViewControllerAnimated(true) {
            print("test")
            let task = NSEntityDescription.insertNewObjectForEntityForName("Tasks", inManagedObjectContext: self.appDel.dataController.managedObjectContext) as! Tasks
            print(self.categoryName)
            task.categoryName = self.categoryName
            task.taskName = self.txtTask.text
            task.notes = self.txtNotes.text
            task.taskDateTime = self.dpDate.date
            task.reminderDateTime = self.dpReminder.date
            
            do {
                try self.appDel.dataController.managedObjectContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
