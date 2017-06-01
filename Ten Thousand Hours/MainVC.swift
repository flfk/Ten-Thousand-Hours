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

    var goals = [Goal]() {
        didSet {
            updateView()
        }
    }
    
    private let persistentContainer = NSPersistentContainer(name: "Goals")
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            } else {
                self.setupView()
            }
        }
        
        
        //Note: don't forget to set tableview datasource and delegate as self in the storyboard
        
        
    }

    //MARK: - Actions
    
    //MARK: - Helper Methods VC
    
    //** updateView only required if NSFetchedResultsController not used to ensure data is updated when data changes
    private func updateView() {
        let hasGoals = goals.count > 0
        
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
        let goal = goals[indexPath.row]
        
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

