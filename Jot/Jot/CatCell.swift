//
//  CatCell.swift
//  Jot
//
//  Created by Greg on 7/28/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit

class CatCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
