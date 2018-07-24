//
//  CategoryTableViewCell.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/11/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var lblNameCategory: UILabel!
    
    @IBOutlet weak var lblNumberCategory: UILabel!
    @IBOutlet weak var lblPriceCategory: UILabel!
    
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
   
    @IBAction func onPlus(_ sender: Any) {
        var i: Int = Int(lblNumberCategory.text!)!
        if i < 20 {
            i += 1
        } else {
            i = 20
        }
        lblNumberCategory.text = "\(i)"
    }
  
    @IBAction func onMinus(_ sender: Any) {
        var i: Int = Int(lblNumberCategory.text!)!
        if i > 0 {
            i -= 1
        } else {
            i = 0
        }
        lblNumberCategory.text = "\(i)"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
