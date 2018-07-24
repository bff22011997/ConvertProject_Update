//
//  LoginViewController.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/9/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
class LoginViewController: UIViewController ,UITextFieldDelegate {

    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnAbout: UIButton!
    @IBOutlet weak var btnLoginFB: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var listUser =  NSMutableArray()
    var j : Int = 0
    var fblogin : FBSDKLoginManager = FBSDKLoginManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.layer.cornerRadius = 8
        btnLoginFB.layer.cornerRadius = 8
        btnRegister.layer.cornerRadius = 8
        btnAbout.layer.cornerRadius = 8
        txtUsername.delegate = self
        txtPassword.delegate = self
//        let reg = RegisterViewController()
//        reg.getListuser()
        let tab = UITapGestureRecognizer(target: self, action: #selector(self.hiddenKB))
        view.addGestureRecognizer(tab)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        listUser = Database.defaultDatabaseManager().getAllUser()
        txtPassword.text = ""
        txtUsername.text = ""
    }

    @IBAction func changeReturnKey(_ sender: Any) {
        if (txtPassword.text == "") {
            txtPassword.enablesReturnKeyAutomatically = true
        } else {
            txtPassword.enablesReturnKeyAutomatically = false
            txtPassword.returnKeyType = .continue
        }
    }
    @objc func hiddenKB() -> Void {
        view.endEditing(true)
    }
    @IBAction func onLogin(_ sender: Any) {
        self.login()
    }
    func login() -> Void {
        if (txtUsername.text == "admin") && (txtPassword.text == "admin") {
            UserDefaults.standard.removeObject(forKey: "check")
            UserDefaults.standard.set(1, forKey: "check")
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            appdelegate?.checkViewHome()
        }
        else {
            if listUser.count == 0 {
                let alert = UIAlertController(title: "ERROR", message: "Please input the account", preferredStyle: .alert)
                let noButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                    return
                })
                alert.addAction(noButton)
                present(alert, animated: true)
            } else {
                for i in 0...listUser.count-1 {
                    let u = listUser.object(at: i) as! Admin
                    if (txtUsername.text == u.name && txtPassword.text == u.password) {
                        j = 1
                        UserDefaults.standard.removeObject(forKey: "check")
                        UserDefaults.standard.set(1, forKey: "check")
                        let appdelegate = UIApplication.shared.delegate as? AppDelegate
                        appdelegate?.checkViewHome()
                        break
                    }
                }
                if (j == 0) {
                    let alert = UIAlertController(title: "ERROR", message: "Please input the account", preferredStyle: .alert)
                    let noButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                        return
                    })
                    alert.addAction(noButton)
                    present(alert, animated: true)
                }
            }
            
        }
        
    }
    @IBAction func onLoginFB(_ sender: Any) {
        loginAppWithFB()
    }
   
    @IBAction func onRegister(_ sender: Any) {
        let regiter : RegisterViewController = RegisterViewController()
        self.navigationController?.pushViewController(regiter, animated: true)
    }
   
    @IBAction func onAbout(_ sender: Any) {
        let about : AboutViewController = AboutViewController()
        self.navigationController?.pushViewController(about, animated: true)
    }
   
    @IBAction func onShowPassword(_ sender: Any) {
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUsername {
            txtPassword.becomeFirstResponder()
        } else {
            view.endEditing(true)
            self.login()
        }
        return true
    }
    func loginAppWithFB() -> Void {
        fblogin.logIn(withReadPermissions: ["email","public_profile","user_birthday","user_friends","user_photos"], from: self) { (result, error) in
            if error == nil {
                self.fetchUserID()
                self.fblogin.logOut()
                FBSDKAccessToken.setCurrent(nil)
                print("dang nhap thanh cong")
            }
            else {
                print("dang nhap that bai")
            }
        }
       
    }
    func fetchUserID() -> Void {
        if (FBSDKAccessToken.current() != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "picture, email,name, birthday,cover"]).start(completionHandler: { connection, result, error in
                if error == nil {
                    let infor = InformationViewController()
                    let resultDict = result as! NSDictionary
                    infor.strName = resultDict.value(forKey: "name") as! String
                    infor.strBirthday = resultDict.value(forKey: "birthday") as! String
                    let resultPicture = resultDict.value(forKey: "picture") as! NSDictionary
                    let resultData = resultPicture.value(forKey: "data") as! NSDictionary
                    infor.linkPicture = resultData.value(forKey: "url") as! String
                    self.navigationController?.pushViewController(infor, animated: true)
                    
                }
            })
            
            
            
        }
    }

  

}
