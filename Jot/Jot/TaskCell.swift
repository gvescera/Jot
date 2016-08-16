//
//  TaskCell.swift
//  Jot
//
//  Created by Greg on 8/5/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var task: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var rDate: UILabel!
    @IBOutlet weak var rTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
