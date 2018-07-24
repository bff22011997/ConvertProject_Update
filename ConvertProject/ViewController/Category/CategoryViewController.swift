//
//  CategoryViewController.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/11/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit
import Alamofire
class CategoryViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {
    var listFood =  NSMutableArray()
    var index : String = ""
    var listData : [[String : AnyObject]] = [[String : AnyObject]]()
    var saveData : NSMutableArray = NSMutableArray()
    var listCategory : NSMutableArray = NSMutableArray()
    var tableNumber : String = ""
    var idFood : String = ""
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate = self
        tblView.register(UINib.init(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
        self.getDataFromAPI()
        self.lblTitle.text = "Table " + self.tableNumber
        // Do any additional setup after loading the view.
    }
    func getDataFromAPI() -> Void {
        MBProgressHUD.showAdded(to: view, animated: true)
        let url : URL  = URL(string : BASE_URL + PRODUCT + "?" + "CategoryId" + "=" + idFood)!
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success:
                if let dictionary = response.result.value as? [String : AnyObject]{
                    DispatchQueue.main.async {
                        self.listData = dictionary["data"] as! [[String : AnyObject]]
                        for i in 0...self.listData.count-1 {
                            let cat = CategoryRestaurent(IDCategory: "",nameCategory: "",codeCategory: "",priceCategory: "",numberNameCategory: "",categoryId: "",isSelected: false)
                            var categoryRes = self.listData[i]
                            cat.IDCategory = categoryRes["id"] as! String
                            cat.codeCategory = String(categoryRes["code"] as! Int)
                            cat.priceCategory = String(categoryRes["price"] as! Int)
                            cat.numberNameCategory = String(categoryRes["numbername"] as! Int)
                            cat.nameCategory = categoryRes["name"] as! String
                            cat.categoryId = categoryRes["categoryId"] as! String
                            self.listCategory.add(cat)
                        }
                        self.tblView.reloadData()
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: (true))
                    }
                    
                }
                break
            case .failure(_):
                print(Error.self)
                MBProgressHUD.hideAllHUDs(for: self.view, animated: (true))
            }
        }
        

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listCategory.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (100 - tableView.bounds.size.height / 6) != 0 ? 100 : tableView.bounds.size.height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        let category = self.listCategory.object(at: indexPath.row) as! CategoryRestaurent
        cell.lblNameCategory.text = category.nameCategory
        cell.lblPriceCategory.text = category.priceCategory
        cell.lblNumberCategory.text = "0"
        cell.btnPlus.addTarget(self, action: #selector(onPlus), for: .touchUpInside)
        cell.btnMinus.addTarget(self, action: #selector(onMinus), for: .touchUpInside)
        cell.btnPlus.tag = indexPath.row
        cell.btnMinus.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    @IBAction func onCart(_ sender: Any) {
        let cart =  CartViewController()
        cart.tableNumber = self.tableNumber
        self.navigationController?.pushViewController(cart, animated: true)
    }
    
    @IBAction func onOrder(_ sender: Any) {
        for i in 0...self.listCategory.count-1 {
            let cat = self.listCategory.object(at: i) as! CategoryRestaurent
            if Int(cat.numberNameCategory)! > 0 {
                self.saveData.add(cat)
            }
        }
        if self.saveData.count == 0 {
            let alert = UIAlertController(title: "NOTIFICATION", message: "You Must Order", preferredStyle: .alert)
            let yesButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                
            })
            
            alert.addAction(yesButton)
            self.present(alert, animated: true,completion: nil)
        } else {
            let order = OrderViewController()
            order.listCategoryOrder = self.saveData
            order.tableNumber  = self.tableNumber
            order.index = self.index
            order.listFood = self.listFood
            self.navigationController?.pushViewController(order, animated: true)
        }

    }
    @IBAction func onPlus(_ sender: UIButton) {
        let i : Int = sender.tag
        let cat = self.listCategory.object(at: i) as! CategoryRestaurent
        let value : Int = Int(cat.numberNameCategory)!
        cat.numberNameCategory = String(value+1)
        self.listCategory.replaceObject(at: i, with: cat)
    }
    @IBAction func onMinus(_ sender: UIButton) {
        let i : Int = sender.tag
        let cat = self.listCategory.object(at: i) as! CategoryRestaurent
        let value : Int = Int(cat.numberNameCategory)!
        cat.numberNameCategory = String(value-1)
        self.listCategory.replaceObject(at: i, with: cat)
    }
    

}
