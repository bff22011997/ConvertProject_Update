//
//  InformationViewController.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/19/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    var strName : String = ""
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var viewMC: MCPercentageDoughnutView!
    var linkCover : String = ""
    @IBOutlet weak var lblBirthday: UILabel!
    var strBirthday : String = ""
    @IBOutlet weak var imagePicture: UIImageView!
    var linkPicture : String = ""
    var shouldStopCountDown = false
    var currentValue: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = strName
        lblBirthday.text = strBirthday
        imagePicture.downloadedFrom(link: linkPicture)

        
        currentValue = 5
        shouldStopCountDown = false
       viewMC.textStyle = MCPercentageDoughnutViewTextStyleUserDefined
        viewMC.percentage = 1
        viewMC.linePercentage = 0.07
        viewMC.animationDuration = 1
        viewMC.showTextLabel = true
        viewMC.animatesBegining = true
        viewMC.textLabel?.textColor = UIColor.black.withAlphaComponent(0.5)
        shouldStopCountDown = false
        MCUtil.run(onAuxiliaryQueue: {
            while self.currentValue > 0 && !self.shouldStopCountDown {
                MCUtil.run(onMainQueue: {
                    self.countDown()
                })
                Thread.sleep(forTimeInterval: 1)
            }
        })
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func countDown() -> Void {
        currentValue -= 1
        viewMC.textLabel?.text = "\(currentValue)"
        viewMC.percentage = CGFloat(Float(currentValue) / 5.0)
        if currentValue == 0 {
            UserDefaults.standard.removeObject(forKey: "check")
            UserDefaults.standard.set(1, forKey: "check")
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            appdelegate?.checkViewHome()
        }
    }
}
