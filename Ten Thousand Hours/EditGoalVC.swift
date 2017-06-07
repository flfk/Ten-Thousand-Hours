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
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //create variable for goal to load data if it exists already
    var goal: Goal?
    
    //create variable for goal date
    var convertedDate: String?
    
    @IBOutlet weak var addTimePicker: UIDatePicker!
    
    //MARK: - Core Data Stack set up
    var managedObjectContext: NSManagedObjectContext?
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the date label equal to the default value of the date picker
        goalDateLabel.text = convertDatePickerToString()
        
        //let date = Date()
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = DateFormatter.Style.long
        //let convertedDate = dateFormatter.string(from: date)
        //goalDateLabel.text = convertedDate
    
        //set default for countdownpicker to 0
        addTimePicker.countDownDuration = 0
        
        //set default for total time labels as 0
        goalHoursLabel.text = "0"
        goalMinutesLabel.text = "0"
        
        //if a goal selected load the available data
        if let goal = goal {
            addGoalNameTxtFld.text = goal.name
            goalHoursLabel.text = "\(Int(goal.totalMinutes/60))"
            goalMinutesLabel.text = "\(Int(goal.totalMinutes.truncatingRemainder(dividingBy: 60)))"
            
            //set title for existing goal
            title = "Add Time"
            
            goalDateLabel.text = goal.createdAt
        } else {
            //set title for new goal
            title = "Add Goal"
        }
        
    }
    
    //MARK: - Actions
    
    @IBAction func datePickerButton(_ sender: Any) {
        datePickerView.isHidden = false
    }
    
    @IBAction func saveDateButton(_ sender: Any) {
        goalDateLabel.text = convertDatePickerToString()
        
        datePickerView.isHidden = true
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        guard let managedObjectContext = managedObjectContext else { return }
        
        if goal == nil {
            //create goal
            let newGoal = Goal(context: managedObjectContext)
            
            //configure goal
            newGoal.name = addGoalNameTxtFld.text
            newGoal.createdAt = convertedDate
            let totalSeconds = addTimePicker.countDownDuration
            newGoal.totalMinutes = newGoal.totalMinutes + totalSeconds/60
            
            //set goal
            goal = newGoal
        }
        
        if let goal = goal {
            //configure goal
            goal.name = addGoalNameTxtFld.text
            goal.createdAt = convertDatePickerToString()
            
            let totalSeconds = addTimePicker.countDownDuration
            goal.totalMinutes = goal.totalMinutes + totalSeconds/60
        }
        
        //pop view controller
        _ = navigationController?.popViewController(animated: true)
        
    }

    
    //MARK: - Navigation
    
    //MARK: - Notification Handling
    
    //MARK: - Helper Methods
    
    func convertDatePickerToString() -> String {
        let date = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        return dateFormatter.string(from: date)
    }
    
}
