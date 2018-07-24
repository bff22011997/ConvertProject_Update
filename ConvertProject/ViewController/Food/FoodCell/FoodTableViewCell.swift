//
//  FoodTableViewCell.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/10/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageFood: UIImageView!
    
    @IBOutlet weak var lblNameFood: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
