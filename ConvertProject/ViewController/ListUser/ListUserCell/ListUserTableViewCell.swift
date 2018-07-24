//
//  ListUserTableViewCell.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/20/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit

class ListUserTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPass: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
