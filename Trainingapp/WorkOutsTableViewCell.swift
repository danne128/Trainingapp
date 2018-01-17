//
//  WorkOutsTableViewCell.swift
//  Trainingapp
//
//  Created by Daniel Trondsen Wallin on 2018-01-17.
//  Copyright © 2018 Daniel Trondsen Wallin. All rights reserved.
//

import UIKit

class WorkOutsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workOutNameLabel: UILabel!
    @IBOutlet weak var amountOfExercisesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
