let dateFormatter = DateFormatter()//
//  MainVC.swift
//  Ten Thousand Hours
//
//  Created by Felix Kramer on 1/6/17.
//  Copyright © 2017 Felix Kramer. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var introductoryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //placeholder only before coredata stack is set up to set up tableview - remove after Core Data Stack Set Up
    //var goals = [Goal]() {
    //    didSet {
    //        updateView()
    //    }
    //}
    
    private let segueAddGoal = "SegueAddGoal"
    private let segueEditGoal = "SegueEditGoal"
    
    //MARK: - Core Data Stack Set Up
    //create core data persistent container and fetched results controller variables and add NSFetchedResultsControllerDelegate to conform to protocol
    
    private let persistentContainer = NSPersistentContainer(name: "Goals")
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Goal> = {
        //create fetch request
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        
        //configure fetch request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        //create fetched request controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        //configure fetched request controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    } ()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Overview"
        
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            } else {
                
                self.setupView()
                
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                
                self.updateView()
            }
        }
        
        //add View Controller as observer so when app enters background it saves changes
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        
        //Note: don't forget to set tableview datasource and delegate as self in the storyboard
        
        
    }

    //MARK: - Actions
    
    //MARK: - Helper Methods VC
    
    //UpdateView updates the user interface
    fileprivate func updateView() {
        var hasGoals = false
        
        if let goals = fetchedResultsController.fetchedObjects {
            hasGoals = goals.count > 0
        }
        
        tableView.isHidden = !hasGoals
        introductoryLabel.isHidden = hasGoals
    }
    
    private func setupMessageLabel() {
        introductoryLabel.text = "You don't have any goals yet."
    }
    
    private func setupView() {
        setupMessageLabel()
        
        updateView()
    }
    
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationViewController = segue.destination as? EditGoalVC else { return }
        
        //configure view controller
        destinationViewController.managedObjectContext = persistentContainer.viewContext
        
        if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == segueEditGoal {
            //configure View Controller
            destinationViewController.goal = fetchedResultsController.object(at: indexPath)
            //deslect the row so that it doesn't remain highlighted
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    
    //MARK: - Notification Handling
    
    func applicationDidEnterBackground(_ notification: Notification) {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
        
        print("Managed Object Context saved to persitent container")
    }


}

extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let goals = fetchedResultsController.fetchedObjects else { return 0 }
        
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GoalCell.reuseIdentifier, for: indexPath) as? GoalCell else {
            fatalError("Unexpected Index Path")
            
        }
        
        configure(cell, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //fetch quote
        let quote = fetchedResultsController.object(at: indexPath)
        
        //delete quote
        quote.managedObjectContext?.delete(quote)
    }
    
    // Helper Methods Table View Extension
    
    func configure(_ cell: GoalCell, at indexPath: IndexPath) {
        
        //fetch goal
        let goal = fetchedResultsController.object(at: indexPath)
        
        //prepare strings for date and time
        let name = goal.name
        let hours = "\(Int(goal.totalMinutes/60))"
        let convertedDate = goal.createdAt
        
        
        //configure goal
        cell.goalNameLabel.text = name
        cell.goalDateLabel.text = convertedDate
        cell.goalTimeLabel.text = hours
    }
    
}

extension MainVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case.update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? GoalCell {
                configure(cell, at: indexPath)
            }
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
    
}

