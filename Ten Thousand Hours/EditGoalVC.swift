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
        goalDateLabel.text = "since " + convertDatePickerToString()
    
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
            
            goalDateLabel.text = "since " + goal.createdAt!
            
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
        goalDateLabel.text = "since " + convertDatePickerToString()
        
        datePickerView.isHidden = true
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        guard let managedObjectContext = managedObjectContext else { return }
        
        if let goal = goal {
            //configure goal
            goal.name = addGoalNameTxtFld.text
            goal.createdAt = convertDatePickerToString()
            
            let totalSeconds = addTimePicker.countDownDuration
            goal.totalMinutes = goal.totalMinutes + totalSeconds/60
        }
        
        if goal == nil {
            //create goal
            let newGoal = Goal(context: managedObjectContext)
            
            //configure goal
            newGoal.name = addGoalNameTxtFld.text
            newGoal.createdAt = convertDatePickerToString()
            let totalSeconds = addTimePicker.countDownDuration
            newGoal.totalMinutes = totalSeconds/60
            
            //set goal
            goal = newGoal
        }
        
        //pop view controller
        _ = navigationController?.popViewController(animated: true)
        
    }

    
    //MARK: - Navigation
    
    //MARK: - Notification Handling
    
    //MARK: - Helper Methods
    
    private func convertDatePickerToString() -> String {
        let date = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        return dateFormatter.string(from: date)
    }
    
}

extension EditGoalVC: UITextFieldDelegate {
    
    //don't forget in the storyboard to set the textfield delegate to the viewcontroller
 
    //hide keyboard when the user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard when the user touches return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addGoalNameTxtFld.resignFirstResponder()
        return true
    }
}
