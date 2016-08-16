//
//  vcTasks.swift
//  Jot
//
//  Created by Greg on 7/27/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import CoreData

class vcTasks: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    // MARK: - Properties
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    var fetchedResultsController: NSFetchedResultsController!
    var categoryName: String!
    var catID: NSManagedObjectID!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        navBar.title = categoryName
        initializeFetchedResultsController()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if taskTable.indexPathForSelectedRow != nil {
            taskTable.deselectRowAtIndexPath(taskTable.indexPathForSelectedRow!, animated: true)
        }
        taskTable.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        self.automaticallyAdjustsScrollViewInsets = false
        configureAddButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections!.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sections = fetchedResultsController.sections! as [NSFetchedResultsSectionInfo]
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = taskTable.dequeueReusableCellWithIdentifier("taskcell", forIndexPath: indexPath) as! TaskCell
        return configureCell(cell, indexPath: indexPath)
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        taskTable.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            taskTable.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            taskTable.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Move:
            break
        case .Update:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            taskTable.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            //configureCell(taskTable.cellForRowAtIndexPath(newIndexPath!) as! TaskCell, indexPath: newIndexPath!)
        case .Delete:
            taskTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            configureCell(taskTable.cellForRowAtIndexPath(indexPath!) as! TaskCell, indexPath: indexPath!)
        case .Move:
            taskTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            taskTable.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        taskTable.endUpdates()
    }
    

    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let task = fetchedResultsController.objectAtIndexPath(indexPath) as! Tasks
            appDel.dataController.managedObjectContext.deleteObject(task)
            appDel.dataController.saveContext()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "vcTaskDetails" {
            let destinationVC = segue.destinationViewController as! vcTaskDetails
            let indexPath = taskTable.indexPathForSelectedRow!
            let task = fetchedResultsController.objectAtIndexPath(indexPath) as! Tasks
            destinationVC.taskID = task.objectID
        }
        if segue.identifier == "vcNewTask" {
            let destinationVC = segue.destinationViewController as! vcNewTask
            destinationVC.categoryName = categoryName
        }
        
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - Custom Functions
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: "Tasks")
        let predicate = NSPredicate(format: "categoryName == '\(categoryName!)'")
        request.predicate = predicate
        let taskSort = NSSortDescriptor(key: "categoryName", ascending: true)
        request.sortDescriptors = [taskSort]
        
        let moc = appDel.dataController.managedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func configureCell(cell: TaskCell, indexPath: NSIndexPath) -> UITableViewCell!{
        let task = fetchedResultsController.objectAtIndexPath(indexPath) as! Tasks
        cell.task.text = task.taskName
        cell.date.text = task.getDate()
        cell.time.text = task.getTime()
        cell.rDate.text = task.getRemDate()
        cell.rTime.text = task.getRemTime()
        return cell
    }
    
    func configureAddButton() {
        let width: CGFloat = self.view.bounds.width - 300.0
        let height: CGFloat = 50.0
        let x: CGFloat = (self.view.bounds.width/2) - (width/2)
        let y: CGFloat = (self.view.bounds.height) - (height*1.5)
        let bgColor: UIColor = UIColor(red: 255/255, green: 128/255, blue: 255/255, alpha: 0.25)
        let txtColor: UIColor = UIColor.whiteColor()
        let addButton = UIButton(type: UIButtonType.System) as UIButton
        
        addButton.backgroundColor = bgColor
        addButton.setTitle("Add", forState: UIControlState.Normal)
        addButton.setTitleColor(txtColor, forState: UIControlState.Normal)
        addButton.frame = CGRect(x: x, y: y, width: width, height: height)
        addButton.layer.cornerRadius = 8.0
        addButton.addTarget(self, action: #selector(self.addTask), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(addButton)
    }

    func addTask() {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcNewTask") as! vcNewTask
        vc.categoryName = categoryName
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    
}
