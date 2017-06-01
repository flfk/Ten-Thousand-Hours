//
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
    
    //MARK: - Core Data Stack Set Up
    //create core data persistent container and fetched results controller variables and add NSFetchedResultsControllerDelegate to conform to protocol
    
    private let persistentContainer = NSPersistentContainer(name: "Goals")
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Goal> = {
        //create fetch request
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        
        //configure fetch request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        //create fetched request controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        //configure fetched request controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    } ()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        //Note: don't forget to set tableview datasource and delegate as self in the storyboard
        
        
    }

    //MARK: - Actions
    
    //MARK: - Helper Methods VC
    
    //** updateView only required if NSFetchedResultsController not used to ensure data is updated when data changes
    private func updateView() {
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
    
    
    //MARK: - Notification Handling


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
    
    // Helper Methods Table View Extension
    
    func configure(_ cell: GoalCell, at indexPath: IndexPath) {
        
        //fetch goal
        let goal = fetchedResultsController.object(at: indexPath)
        
        //prepare strings for date and time
        let name = goal.name
        let date = "\(goal.createdAt)"
        let hours = "\(goal.totalMinutes/60)"
        
        //configure goal
        cell.goalNameLabel.text = name
        cell.goalDateLabel.text = date
        cell.goalTimeLabel.text = hours
    }
    
}

extension MainVC: NSFetchedResultsControllerDelegate {
    
}

