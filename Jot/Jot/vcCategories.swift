//
//  vcCategories.swift
//  Jot
//
//  Created by Greg on 7/27/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import CoreData

class vcCategories: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    @IBOutlet weak var catTable: UITableView!
    
    // MARK: - Variables
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    var fetchedResultsController: NSFetchedResultsController!

    
    // MARK: - Default Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        initializeFetchedResultsController()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if catTable.indexPathForSelectedRow != nil {
            catTable.deselectRowAtIndexPath(catTable.indexPathForSelectedRow!, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
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
        let cell = catTable.dequeueReusableCellWithIdentifier("catcell", forIndexPath: indexPath) as! CatCell
        return configureCell(cell, indexPath: indexPath)
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        catTable.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            catTable.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            catTable.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Move:
            break
        case .Update:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            catTable.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            catTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            configureCell(catTable.cellForRowAtIndexPath(indexPath!) as! CatCell, indexPath: indexPath!)
        case .Move:
            catTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            catTable.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        catTable.endUpdates()
    }
    
    
     // Override to support conditional editing of the table view.
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
    
  
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            catDeleteConfirm(indexPath)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
//    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//
//    }
    

    
    // Override to support conditional rearranging of the table view.
//    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
    
    
     
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "vcTasks" {
            let destinationVC = segue.destinationViewController as! vcTasks
            let indexPath = catTable.indexPathForSelectedRow!
            let cat = fetchedResultsController.objectAtIndexPath(indexPath) as! Categories
            destinationVC.categoryName = cat.category
            destinationVC.catID = cat.objectID

        }
        // Pass the selected object to the new view controller.
    }
    
    
    
    // MARK: - Custom Functions
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: "Categories")
        let catSort = NSSortDescriptor(key: "category", ascending: true)
        request.sortDescriptors = [catSort]
        
        let moc = appDel.dataController.managedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func configureCell(cell: CatCell, indexPath: NSIndexPath) -> CatCell{
        let cat = fetchedResultsController.objectAtIndexPath(indexPath) as! Categories
        cell.title.text = cat.category
        cell.progressBar.setProgress(0.25, animated: false)
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
        addButton.addTarget(self, action: #selector(self.addCat), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(addButton)
    }
    
    func addCat(addButton: UIButton) {
        var catInput: UITextField = UITextField()
        let catAlert: UIAlertController = UIAlertController(title: "New Category", message: "Please enter a new category.", preferredStyle: .Alert)
        let create: UIAlertAction = UIAlertAction(title: "Create", style: .Default, handler: { (action) -> Void in
            let text = catInput.text
            self.saveCat(text!)
        })
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            
        })
        
        catAlert.addTextFieldWithConfigurationHandler( { (textField: UITextField) in
            catInput = textField
        })
        catInput.placeholder = "Category"
        
        catAlert.addAction(create)
        catAlert.addAction(cancel)
        presentViewController(catAlert, animated: true, completion: nil)
        
    }
    
    func saveCat(catName: String) {
        let cat = NSEntityDescription.insertNewObjectForEntityForName("Categories", inManagedObjectContext: appDel.dataController.managedObjectContext) as! Categories

        cat.category = catName
        
        do {
            try appDel.dataController.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

    func catDeleteConfirm(indexPath: NSIndexPath) {
        let confirmation = UIAlertController(title: "Are you sure?", message: "Deleting this category will delete all of its tasks.", preferredStyle: .Alert)
        let delete = UIAlertAction(title: "Delete", style: .Destructive) { (action) -> Void in
            self.deleteCat(indexPath)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in

        }
        confirmation.addAction(delete)
        confirmation.addAction(cancel)
        presentViewController(confirmation, animated: true, completion: nil)
    }
    
    func deleteCat(indexPath: NSIndexPath) {
        let moc = appDel.dataController.managedObjectContext
        let cat = fetchedResultsController.objectAtIndexPath(indexPath) as! Categories
        let request = NSFetchRequest(entityName: "Tasks")
        let predicate = NSPredicate(format: "categoryName == '\(cat.category!)'")
        request.predicate = predicate
        do {
            let tasks = try moc.executeFetchRequest(request) as! [Tasks]
            for task in tasks {
                print(task.categoryName)
                moc.deleteObject(task)
            }
            moc.deleteObject(cat)
            
        } catch {
            
        }
        
        appDel.dataController.saveContext()
    }
    
    
}

