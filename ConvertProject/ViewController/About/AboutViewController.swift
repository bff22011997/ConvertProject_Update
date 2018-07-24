//
//  AboutViewController.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/9/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onMenu(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
    }
   
    @IBAction func onContract(_ sender: Any) {
        let application = UIApplication.shared
        if let astring = URL(string: "tel:0986485643") {
            application.open(astring, options: [:] , completionHandler: nil)
        }
    }
    
    
    @IBAction func onFacebook(_ sender: Any) {
        let myurl = "https://www.facebook.com/soi.convuive"
        let url = URL(string: myurl)
        if let anUrl = url {
            UIApplication.shared.open(anUrl, options: [ : ], completionHandler: nil)
        }
    }
    

}
