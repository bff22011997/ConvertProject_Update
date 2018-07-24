//
//  RegisterViewController.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/9/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit
//import SQLite
class RegisterViewController: UIViewController , UITextFieldDelegate{
//    var database : Connection!
    var check : Int = 0
//    let userTable = Table("users")
//    let id = Expression<Int>("id")
//    let username = Expression<String>("username")
//    let password = Expression<String>("password")
    @IBOutlet weak var txtConfirm: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    var listUser = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
//            do {
//                let documentDirectory  = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:true)
//                let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
//                let database = try Connection(fileUrl.path)
//                self.database = database
//            } catch  {
//
//            }
//            let createTable = self.userTable.create { (table) in
//                table.column(self.id , primaryKey : true)
//                table.column(self.username)
//                table.column(self.password)
//            }
//
//            do {
//                try self.database.run(createTable)
//            } catch  {
//                print(error)
//            }
        let tab = UITapGestureRecognizer(target: self, action: #selector(self.hiddenKB))
        view.addGestureRecognizer(tab)
        txtUsername.delegate = self
        txtPassword.delegate = self
        txtConfirm.delegate = self
        listUser = Database.defaultDatabaseManager().getAllUser()
    }
    @objc func hiddenKB() -> Void {
        view.endEditing(true)
    }
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUsername {
            txtPassword.becomeFirstResponder()
        } else if textField == txtPassword {
            txtConfirm.becomeFirstResponder()
        } else {
            view.endEditing(true)
            self.register()
        }
        return true
    }
    func register() -> Void {
        if txtUsername.text == "admin" {
            let alert = UIAlertController(title: "ERROR", message: "Username already exist", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true)
            })
            alert.addAction(okButton)
            present(alert, animated: true)
        }
        else if (txtUsername.text == "")  || (txtPassword.text == "") || (txtConfirm.text == ""){
            let alert = UIAlertController(title: "ERROR", message: "Enter the full information", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true)
            })
            alert.addAction(okButton)
            present(alert, animated: true)
        }
        else if (txtConfirm.text != txtPassword.text) {
            let alert = UIAlertController(title: "ERROR", message: "Password must be as same as Confirm", preferredStyle: .alert)
            let yesButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true)
            })
            alert.addAction(yesButton)
            present(alert, animated: true)
            
        }
        else {
            if gArrayListUser.count == 0 {
                let a = Admin()
                a.name = txtUsername.text
                a.password = txtPassword.text
                Database.defaultDatabaseManager().insertUser(a)
                UserDefaults.standard.removeObject(forKey: "checkAddUser")
                UserDefaults.standard.set("1", forKey: "checkAddUser")
//                let insertUser = self.userTable.insert(self.username <- txtUsername.text! , self.password <- txtPassword.text!)
//                do {
//                    try self.database.run(insertUser)
//                } catch  {
//                    print(error)
//                }
                let alert = UIAlertController(title: "SUCCESS", message: "Register success", preferredStyle: .alert)
                let noButton = UIAlertAction(title: "OK", style: .default, handler: { action in
//                    do {
////                        let users = try self.database.prepare(self.userTable)
////                        for user in users {
////                            let u = User()
////                            u.Username = user[self.username]
////                            u.Password = user[self.password]
////                            u.ID = String(user[self.id])
////                            gArrayListUser.add(u)
//                        //}
//                    } catch  {
//                        print(error)
//                    }
                    self.navigationController?.popViewController(animated: true)
                    
                })
                alert.addAction(noButton)
                check = 0
                present(alert, animated: true)
            } else {
                for i in 0...listUser.count-1 {
                    let u = listUser.object(at: i) as! User
                    if txtUsername.text == u.Username {
                        let alert = UIAlertController(title: "ERROR", message: "Username already exist", preferredStyle: .alert)
                        let noButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                            
                        })
                        alert.addAction(noButton)
                        present(alert, animated: true)
                        check = 1
                        break
                    }
                }
                if check == 0 {
                    let a = Admin()
                    a.name = txtUsername.text
                    a.password = txtPassword.text
                    Database.defaultDatabaseManager().insertUser(a)
                    UserDefaults.standard.removeObject(forKey: "checkAddUser")
                    UserDefaults.standard.set("1", forKey: "checkAddUser")
//                    let insertUser = self.userTable.insert(self.username <- txtUsername.text! , self.password <- txtPassword.text!)
//                    do {
//                        try self.database.run(insertUser)
//                    } catch  {
//                        print(error)
//                    }
//                    do {
//                        let users = try self.database.prepare(self.userTable)
//                        gArrayListUser.removeAllObjects()
//                        for user in users {
//                            let u = User()
//                            u.Username = user[username]
//                            u.Password = user[password]
//                            u.ID = String(user[self.id])
//                            gArrayListUser.add(u)
//                        }
//                    } catch  {
//                        print(error)
//                    }
                    let alert = UIAlertController(title: "SUCCESS", message: "Register success", preferredStyle: .alert)
                    let noButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                        return
                    })
                    alert.addAction(noButton)
                    check = 0
                    present(alert, animated: true)
                }
            }
            
        }
    }
//    func getListuser() -> Void {
//         gArrayListUser.removeAllObjects()
//        do {
//            let documentDirectory  = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:true)
//            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
//            let database = try Connection(fileUrl.path)
//            self.database = database
//        } catch  {
//
//        }
//        let createTable = self.userTable.create { (table) in
//            table.column(self.id , primaryKey : true)
//            table.column(self.username)
//            table.column(self.password)
//        }
//
//        do {
//            try self.database.run(createTable)
//        } catch  {
//            print(error)
//        }
//        do {
//            let users = try self.database.prepare(self.userTable)
//            for user in users {
//                let u = User()
//                u.Username = user[username]
//                u.Password = user[password]
//                u.ID = String(user[self.id])
//                gArrayListUser.add(u)
//            }
//        } catch  {
//            print(error)
//        }
//    }
    @IBAction func onRegister(_ sender: Any) {
        register()
    }
//    func deleteUser(name : String) -> Void {
//        let user = self.userTable.filter(self.id  == Int(name)!)
//        let deleteUser = user.delete()
//        do {
//            try self.database.run(deleteUser)
//        } catch  {
//            print(error)
//        }
//    }
    
    

}
