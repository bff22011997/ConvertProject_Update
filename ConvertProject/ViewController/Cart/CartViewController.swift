//
//  CartViewController.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/16/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit
import Alamofire

class CartViewController: UIViewController , PayPalPaymentDelegate, UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var lblSumPrice: UILabel!
    var payPalconfig: PayPalConfiguration?
    var listData : [[String : AnyObject]] = [[String : AnyObject]]()
    var tableNumber : String = ""
    var listCategory : NSMutableArray = NSMutableArray()
    var sum : Int = 0
    var listPayment = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate = self
        tblView.register(UINib.init(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getDataFromAPI()
        let s = Support()
        let arr : NSArray = s.getArrayObjectFromNSUserDefault(key: "listPayment")
        listPayment = NSMutableArray(array: arr)
    }
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCategory.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as! CartTableViewCell
        let cart : CategoryRestaurent = listCategory.object(at: indexPath.row) as! CategoryRestaurent
        cell.lblNumber.text = String(indexPath.row + 1)
        cell.lblName.text = cart.nameCategory
        let s = Support()
        cell.lblPrice.text = s.formatterString(str:cart.priceCategory )
        cell.selectionStyle = .none
        //cell.lblPrice.text = cart.priceCategory
        return cell
        
    }
    func getDataFromAPI() -> Void {
        listCategory.removeAllObjects()
        self.sum = 0
         MBProgressHUD.showAdded(to: view, animated: true)
        let url : URL  = URL(string : BASE_URL + SHOW_CART + "?" + "tableId" + "=" + tableNumber)!
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success :
                if let dictionary = response.result.value as? [String : AnyObject]{
                    DispatchQueue.main.async {
                        self.listData = dictionary["data"] as! [[String : AnyObject]]
                        if self.listData.count == 0 {
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: (true))
                            self.btnPay.isUserInteractionEnabled = false
                            self.btnPay.alpha = 0.3
                            return
                        }
                        else {
                            self.btnPay.isUserInteractionEnabled = true
                            self.btnPay.alpha = 1
                            for i in 0...self.listData.count-1 {
                                let cart = CategoryRestaurent(IDCategory: "",nameCategory: "",codeCategory: "",priceCategory: "",numberNameCategory: "",categoryId: "",isSelected: false)
                                var categoryRes = self.listData[i]
                                cart.priceCategory = String(categoryRes["price"] as! Int)
                                cart.numberNameCategory = categoryRes["numberCart"] as! String
                                cart.nameCategory = categoryRes["cartName"] as! String
                                cart.categoryId = categoryRes["cartId"] as! String
                                self.listCategory.add(cart)
                            }
                            self.tblView.reloadData()
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: (true))
                            for i in 0...self.listCategory.count-1 {
                                let cart : CategoryRestaurent = self.listCategory.object(at: i) as! CategoryRestaurent
                                self.sum +=  Int(cart.priceCategory)!
                            }
                            let s = Support()
                            self.lblSumPrice.text = s.formatterString(str: String(self.sum))
                        }
                        
                    }
                }
                break
            case .failure(_):
                print(Error.self)
                MBProgressHUD.hideAllHUDs(for: self.view, animated: (true))
            }
        }
    }
    @IBAction func onHome(_ sender: Any) {
        self.onHomeButton()
    }
    func onHomeButton() -> Void {
        for controller: UIViewController? in navigationController?.viewControllers ?? [UIViewController?]() {
            if (controller is HomeViewController) {
                if let aController = controller {
                    navigationController?.popToViewController(aController, animated: true)
                }
                break
            }
        }
    }
    
    @IBAction func onPay(_ sender: Any) {
        let alert = UIAlertController(title: "PAY", message: "Payment", preferredStyle: .alert)
        let moneyButton = UIAlertAction(title: "Money", style: .default, handler: { action in
           self.paymentMoney()
        })
        let paypalButton = UIAlertAction(title: "Paypal", style: .default, handler: { action in
            self.paypalButton()
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            
        })
        
        alert.addAction(moneyButton)
        alert.addAction(paypalButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
    }
    func paymentMoney() -> Void {
        MBProgressHUD.showAdded(to: view, animated: true)
        let cartID = self.listCategory.object(at: 0) as! CategoryRestaurent
        let url : URL  = URL(string : BASE_URL + ADD_HISTORY + "?" + "tableId" + "=" + tableNumber + "&" + "cartId" + "=" + cartID.categoryId)!
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success :
                self.paidMoney()
                
                MBProgressHUD.hideAllHUDs(for: self.view, animated: (true))
                break
            case .failure(_):
                print(Error.self)
                MBProgressHUD.hideAllHUDs(for: self.view, animated: (true))
                
            }
        }
    }
    func paidMoney() -> Void {
        MBProgressHUD.showAdded(to: view, animated: true)
        let url : URL  = URL(string : BASE_URL + UP_STATUS + "?" + "TableId" + "=" + tableNumber + "&" + "status" + "=" + "2")!
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "PAYMENT", message: "Payment Successfully", preferredStyle: .alert)
                    let yesButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.onHomeButton()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let his = History()
                        his.table = self.tableNumber
                        his.price = self.lblSumPrice.text
                        his.date = dateFormatter.string(from: Date())
                        self.listPayment.add(his)
                        let s = Support()
                        s.saveArrayObjectToUserDefault(array : self.listPayment , key : "listPayment")
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: (true))
                    })
                    
                    alert.addAction(yesButton)
                    self.present(alert, animated: true,completion: self.onHomeButton)
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: (true))
                }
                break
            case .failure(_):
                print(Error.self)
                MBProgressHUD.hideAllHUDs(for: self.view, animated: (true))
                
            }
        }
    }
    func paypalButton() -> Void {
        let stringWithouCurrent = (self.lblSumPrice.text as NSString?)?.substring(from: 1)
        let stringPrice = stringWithouCurrent?.replacingOccurrences(of: ",", with: "")
        let item1 = PayPalItem(name: "Payment Table \(tableNumber)", withQuantity: 1, withPrice: NSDecimalNumber(string: stringPrice), withCurrency: "USD", withSku: "Pay")
        let item = [item1]
        let subtotal = NSDecimalNumber(string: stringPrice)
        let shipping = NSDecimalNumber(string: "0")
        let tax = NSDecimalNumber(string: "0")
        let paymentdetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        let toal: NSDecimalNumber? = subtotal.adding(shipping).adding(tax)
        let payment = PayPalPayment()
        payment.amount = toal!
        payment.currencyCode = "USD"
        payment.shortDescription = "Payment Table \(tableNumber)"
        payment.items = item
        payment.paymentDetails = paymentdetails
        let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalconfig, delegate: self)
        present(paymentViewController!, animated: true)
    }
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        dismiss(animated: true)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        self.paymentMoney()
        dismiss(animated: true)

    }
    
}
