
//
//  ManagerViewController.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/20/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit

class ManagerViewController: UIViewController {

    @IBOutlet weak var btnListPayment: UIButton!
    @IBOutlet weak var btnUser: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnUser.layer.cornerRadius = btnUser.frame.size.height/2
        btnListPayment.layer.cornerRadius = btnListPayment.frame.size.height/2
    }

  
    @IBAction func onMenu(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
    }
    @IBAction func onListUser(_ sender: Any) {
        let listUser = ListUserViewController()
        self.navigationController?.pushViewController(listUser, animated: true)
    }
    
    @IBAction func onListPayment(_ sender: Any) {
        let listPayment = ListPaymentViewController()
        self.navigationController?.pushViewController(listPayment, animated: true)
    }
    
}
