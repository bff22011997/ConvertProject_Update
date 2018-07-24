//
//  OrderTableViewCell.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/11/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var imageCategory: UIImageView!
    
    @IBOutlet weak var btnSub: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblSumTotal: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func onAdd(_ sender: Any) {
        var i: Int = Int(lblNumber.text!)!
        if i < 20 {
            i += 1
        } else {
            i = 20
        }
        lblNumber.text = "\(i)"
    }
    
    @IBAction func onSub(_ sender: Any) {
        var i: Int = Int(lblNumber.text!)!
        if i > 0 {
            i -= 1
        } else {
            i = 0
        }
        lblNumber.text = "\(i)"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
