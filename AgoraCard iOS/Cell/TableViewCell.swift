//
//  TableViewCell.swift
//  TableViewPractice
//
//  Created by Alex Faltermeier on 11.05.19.
//  Copyright © 2019 Alex Faltermeier. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var trainingName: UILabel!
    @IBOutlet weak var trainingDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func commonInit(_ training: String, date: String){
        trainingName.text = training
        trainingDate.text = date
    }
}
