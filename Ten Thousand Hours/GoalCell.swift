//
//  GoalCell.swift
//  Ten Thousand Hours
//
//  Created by Felix Kramer on 1/6/17.
//  Copyright © 2017 Felix Kramer. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var goalNameLabel: UILabel!
    @IBOutlet weak var goalDateLabel: UILabel!
    @IBOutlet weak var goalTimeLabel: UILabel!
    
    //MARK: - 
    
    static let reuseIdentifier = "GoalCell"
    
    //MARK: - Initialisation

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    //MARK: - Actions
    

}
