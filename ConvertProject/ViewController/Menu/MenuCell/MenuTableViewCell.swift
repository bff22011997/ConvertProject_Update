//
//  MenuTableViewCell.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/9/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var imageIcon: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
