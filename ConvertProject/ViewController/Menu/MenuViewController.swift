//
//  MenuViewController.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/9/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tblView: UITableView!
    var arrIcon : NSMutableArray = NSMutableArray()
    var arrTitle = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        arrIcon = ["ic_home.png", "ic_logout.jpeg", "ic_about.jpeg", "ic_menu.png"]
        arrTitle = ["Home", "Logout", "About", "Manager"]
        tblView.dataSource = self
        tblView.delegate = self
        tblView.register(UINib.init(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arrIcon.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.imageIcon.image = UIImage.init(named: arrIcon.object(at: indexPath.row) as! String)
        cell.lblTitle.text = arrTitle.object(at: indexPath.row) as? String
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let home = HomeViewController()
        let narHome = UINavigationController.init(rootViewController: home)
        narHome.isNavigationBarHidden = true
        
        let about = AboutViewController()
        let narAbout = UINavigationController.init(rootViewController: about)
        narAbout.isNavigationBarHidden = true
        
        let manager = ManagerViewController()
        let narManager = UINavigationController.init(rootViewController: manager)
        narManager.isNavigationBarHidden = true
        
        let reveal : SWRevealViewController = self.revealViewController()
        if (indexPath.row == 0 ) {
            reveal.pushFrontViewController(narHome, animated: true)
        } else if (indexPath.row == 1) {
            let alert = UIAlertController(title: "NOTIFICATION", message: "Do you want logout", preferredStyle: .alert)
            let yesButton = UIAlertAction(title: "YES", style: .default, handler: { action in
                UserDefaults.standard.removeObject(forKey: "check")
                UserDefaults.standard.set("0", forKey: "check")
                let appdelegate = UIApplication.shared.delegate as? AppDelegate
                appdelegate?.checkViewLogin()
            })
            let noButton = UIAlertAction(title: "NO", style: .default, handler: { action in
            })
            alert.addAction(yesButton)
            alert.addAction(noButton)
            present(alert, animated: true)
        } else if (indexPath.row == 2) {
            reveal.pushFrontViewController(narAbout, animated: true)
        } else {
            reveal.pushFrontViewController(narManager, animated: true)
        }
    }

}
