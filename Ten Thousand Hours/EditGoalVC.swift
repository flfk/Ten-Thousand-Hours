//
//  EditGoalVC.swift
//  Ten Thousand Hours
//
//  Created by Felix Kramer on 1/6/17.
//  Copyright © 2017 Felix Kramer. All rights reserved.
//

import UIKit
import CoreData

class EditGoalVC: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var addGoalNameTxtFld: UITextField!
    @IBOutlet weak var goalDateLabel: UILabel!
    @IBOutlet weak var goalHoursLabel: UILabel!
    @IBOutlet weak var goalMinutesLabel: UILabel!
    
    @IBOutlet weak var addTimePicker: UIDatePicker!
    
    //MARK: - Core Data Stack set up
    var managedObjectContext: NSManagedObjectContext?
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        let convertedDate = dateFormatter.string(from: date)
        goalDateLabel.text = convertedDate
    
        //set default for countdownpicker to 0
        addTimePicker.countDownDuration = 0
        
        //set default for total time labels as 0
        goalHoursLabel.text = "0"
        goalMinutesLabel.text = "0"
        
    }
    
    //MARK: - Actions
    
    @IBAction func saveButton(_ sender: Any) {
        guard let managedObjectContext = managedObjectContext else { return }
        
        //create goal
        let goal = Goal(context: managedObjectContext)
        
        //configure goal
        goal.name = addGoalNameTxtFld.text
        goal.createdAt = NSDate()
        //**PLACEHOLDER NEED TO ADD UI PICKED TO ADD INITIAL TIME
        let totalSeconds = addTimePicker.countDownDuration
        goal.totalMinutes = goal.totalMinutes + totalSeconds/60
        
        //pop view controller
        _ = navigationController?.popViewController(animated: true)
        
    }

    
    //MARK: - Navigation
    
    
    //MARK: - Notification Handling
    
    //MARK: - Helper Methods
    
    //update the labels for the picker view
    func didSelectTime(sender: UIDatePicker) {
        //to update the labels when a different time is selected
        let addTime = addTimePicker.countDownDuration
        let minutes = Int(addTime/60)
        let hours = Int(addTime/60/60)
        
        goalMinutesLabel.text = "\(minutes)"
        goalHoursLabel.text = "\(hours)"
        
        print("\(hours) hours, \(minutes) minutes")
        
    }
    
}
