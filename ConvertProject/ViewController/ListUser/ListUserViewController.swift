//
//  ListUserViewController.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/20/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit

class ListUserViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblView: UITableView!
    var listUser = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib.init(nibName: "ListUserTableViewCell", bundle: nil), forCellReuseIdentifier: "ListUserTableViewCell")
    
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        listUser = Database.defaultDatabaseManager().getAllUser()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUser.count + 1
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let u : Admin = listUser.object(at: indexPath.row-1) as! Admin
            if editingStyle == .delete {
                let alert = UIAlertController(title: "Delete User From List", message: "Are You Sure Want to Delete!", preferredStyle: .alert)
                let yesButton = UIAlertAction(title: "YES", style: .default, handler: { action in
                    Database.defaultDatabaseManager().deleteUser(withID: u.name)
                    self.listUser.remove(u)
                    self.tblView.reloadData()

                })
                let noButton = UIAlertAction(title: "NO", style: .default, handler: { action in
                })
                alert.addAction(yesButton)
                alert.addAction(noButton)
                present(alert, animated: true)
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListUserTableViewCell") as! ListUserTableViewCell
        if (indexPath.row == 0) {
            cell.lblUsername.text = "admin"
            cell.lblPass.text = "admin"
        } else {
            let u = listUser.object(at: indexPath.row-1) as! Admin
            cell.lblUsername.text = u.name
            cell.lblPass.text = u.password
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    


}
