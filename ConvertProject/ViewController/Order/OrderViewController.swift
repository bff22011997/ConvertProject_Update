//
//  OrderViewController.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/11/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit
import Alamofire
class OrderViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    var tableNumber : String = ""
    var index : String = ""
    var listFood = NSMutableArray()
    var listCategoryOrder : NSMutableArray = NSMutableArray()
    var listCategoryDelete : NSMutableArray = NSMutableArray()
    var sum : Int = 0
    @IBOutlet weak var lblSumTotal: UILabel!
    @IBOutlet weak var tblView: UITableView!
   
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.dataSource = self
        self.tblView.delegate = self
        tblView.register(UINib.init(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")

        
            for i in 0...self.listCategoryOrder.count-1  {
                let cat =  listCategoryOrder.object(at: i) as! CategoryRestaurent
                sum = sum +  Int(cat.priceCategory)! * Int(cat.numberNameCategory)!
            }
            let s = Support()
            lblSumTotal.text = s.formatterString(str: String(sum))
    
        lblTitle.text = "Table " + tableNumber
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (100 - tableView.bounds.size.height / 5) != 0 ? 100 : tableView.bounds.size.height / 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCategoryOrder.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell") as! OrderTableViewCell
        let cat = listCategoryOrder.object(at: indexPath.row) as! CategoryRestaurent
        let food = self.listFood.object(at: Int(index)!) as! FoodRestaurent
        cell.imageCategory.downloadedFrom(link: food.foodImage)
        cell.accessoryType = cat.isSelected ? .checkmark : .none
        cell.lblName.text = cat.nameCategory
        cell.lblPrice.text = cat.priceCategory
        cell.lblNumber.text = cat.numberNameCategory
        let s = Support()
        cell.lblSumTotal.text = s.formatterString(str: String(Int(cat.priceCategory)! * Int(cat.numberNameCategory)!))
        cell.btnAdd.addTarget(self, action: #selector(onPlus), for: .touchUpInside)
        cell.btnSub.addTarget(self, action: #selector(onMinus), for: .touchUpInside)
        cell.btnAdd.tag = indexPath.row
        cell.btnSub.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cat = listCategoryOrder.object(at: indexPath.row) as! CategoryRestaurent
        cat.isSelected = !cat.isSelected
        if cat.isSelected {
            listCategoryDelete.add(cat)
        } else {
            listCategoryDelete.remove(cat)
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tblView.reloadData()
    }
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onHome(_ sender: Any) {
        self.onHomeButton()
    }
    
    @IBAction func onDelete(_ sender: Any) {
        for i in 0...self.listCategoryDelete.count-1 {
            let cat = listCategoryDelete.object(at: i) as! CategoryRestaurent
            self.listCategoryOrder.remove(cat)
        }
        self.tblView.reloadData()
        self.listCategoryDelete.removeAllObjects()
        sum = 0
        if listCategoryOrder.count == 0 {
            sum = 0
            let s = Support()
            lblSumTotal.text = s.formatterString(str: String(sum))
        }
        else {
            for i in 0...self.listCategoryOrder.count-1  {
                let cat =  listCategoryOrder.object(at: i) as! CategoryRestaurent
                sum = sum +  Int(cat.priceCategory)! * Int(cat.numberNameCategory)!
            }
            
            let s = Support()
            lblSumTotal.text = s.formatterString(str: String(sum))
        }
        
    }
    
    @IBAction func onOrder(_ sender: Any) {
         MBProgressHUD.showAdded(to: view, animated: true)
        let dict : NSDictionary = ["data" : self.createArrayDictionaries()]
        let strJson  = self.convertDictionaryToString(dict: dict)
        
        
        let url = BASE_URL + ADD_BOOKING
        let _param = ["json": strJson] as [String : Any]
        do {
            let urlRequest = try URLRequest(url: URL(string: (url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))!, method: .post, headers: nil)
            let encodedURLRequest = try URLEncoding.queryString.encode(urlRequest, with: _param)
            Alamofire.request(encodedURLRequest).responseJSON { (response) in
                self.paidMoney()
                MBProgressHUD.hideAllHUDs(for: self.view, animated: (true))
            }
        } catch {
            MBProgressHUD.hideAllHUDs(for: self.view, animated: (true))
        }
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
    func paidMoney() -> Void {
         MBProgressHUD.showAdded(to: view, animated: true)
        let url : URL  = URL(string : BASE_URL + UP_STATUS + "?" + "TableId" + "=" + tableNumber + "&" + "status" + "=" + "1")!
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "NOTIFICATION", message: "Order Successfully", preferredStyle: .alert)
                    let yesButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.onHomeButton()
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
    func createArrayDictionaries() -> NSArray {
        let arrDictionnaries : NSMutableArray = NSMutableArray()
        if (UserDefaults.standard.string(forKey: tableNumber)?.count ?? 0) == 0 {
            let timeStamp: TimeInterval = Date().timeIntervalSince1970
            let timeStampObj = timeStamp
            let timeStampString = String(format: "%.0f", Float(timeStampObj))
            UserDefaults.standard.set(timeStampString, forKey: tableNumber)
        }
        for i in 0...self.listCategoryOrder.count-1 {
            let cat = self.listCategoryOrder.object(at: i) as! CategoryRestaurent
            var objectFoodDictionary = NSDictionary()
            let aCategory = cat.numberNameCategory
            let aCategory1 = cat.priceCategory
            let aCategory2 = cat.nameCategory
            let aCategory3 = cat.categoryId
                objectFoodDictionary = [NUMBER_CART: aCategory, PRICE: aCategory1, CART_NAME: aCategory2, "cartID": UserDefaults.standard.string(forKey: tableNumber) ?? 0, TABLE_ID: tableNumber, NOTE: "", PRODUCT_ID: aCategory3]
            
            let aDictionary = objectFoodDictionary
            arrDictionnaries.add(aDictionary)
            
        }
        return arrDictionnaries
    }
    
    func convertDictionaryToString(dict : NSDictionary) -> String {
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: dict, options: [])
        var jsonString = ""
        if jsonData == nil {
        } else {
            jsonString = String(data: jsonData!, encoding: .utf8)!
        }
        return jsonString
    }
    @IBAction func onPlus(_ sender: UIButton) {
        let i : Int = sender.tag
        let cat = self.listCategoryOrder.object(at: i) as! CategoryRestaurent
        var value : Int = Int(cat.numberNameCategory)!
        if value == 20 {
            value = 20
        } else {
            cat.numberNameCategory = String(value+1)
        }
        self.listCategoryOrder.replaceObject(at: i, with: cat)
        self.tblView.reloadData()
        sum = 0
        for i in 0...self.listCategoryOrder.count-1  {
            let cat =  listCategoryOrder.object(at: i) as! CategoryRestaurent
            sum = sum +  Int(cat.priceCategory)! * Int(cat.numberNameCategory)!
        }
        let s = Support()
        lblSumTotal.text = s.formatterString(str: String(sum))
    }
    @IBAction func onMinus(_ sender: UIButton) {
        let i : Int = sender.tag
        let cat = self.listCategoryOrder.object(at: i) as! CategoryRestaurent
        let value : Int = Int(cat.numberNameCategory)!
        if Int(cat.numberNameCategory) != 0 {
             cat.numberNameCategory = String(value-1)
        }
       
        self.listCategoryOrder.replaceObject(at: i, with: cat)
        self.tblView.reloadData()
        sum = 0
        for i in 0...self.listCategoryOrder.count-1  {
            let cat =  listCategoryOrder.object(at: i) as! CategoryRestaurent
            sum = sum +  Int(cat.priceCategory)! * Int(cat.numberNameCategory)!
        }
        let s = Support()
        lblSumTotal.text = s.formatterString(str: String(sum))
    }
    
    
}
