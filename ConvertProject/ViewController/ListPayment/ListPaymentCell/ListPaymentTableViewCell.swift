//
//  ListPaymentTableViewCell.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/20/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit

class ListPaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTable: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
