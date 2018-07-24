//
//  FoodViewController.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/10/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit
import Alamofire

class FoodViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    var check : Int = 0
    var listFoodAdd = NSMutableArray()
    var listData : [[String : AnyObject]] = [[String : AnyObject]]()
    var listFood : NSMutableArray = NSMutableArray()
    var tableNumber = ""
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate =  self
        tblView.register(UINib.init(nibName: "FoodTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodTableViewCell")
        self.getDataFromAPI()
        self.lblTitle.text = "Table " + tableNumber
        tblView.addPullToRefresh {
            self.insertRowAtTop()
        }
        tblView.addInfiniteScrolling {
            self.insertRowAtBottom()
        }
        let refreshControl = UIRefreshControl()
        tblView.refreshControl = refreshControl
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if tblView.refreshControl?.isRefreshing != nil {
            refresh()
        }
    }
    
    func refresh() {
        self.tblView.refreshControl?.endRefreshing()
        self.tblView.reloadData()
    }
    func insertRowAtTop() {
        check = 0
        self.getDataFromAPI()
        tblView.infiniteScrollingView.stopAnimating()
    }
    func insertRowAtBottom() {
        check = check + 1
        self.getDataFromAPI()
        tblView.infiniteScrollingView.stopAnimating()
        
    }
    func getDataFromAPI() -> Void {
        self.listFood.removeAllObjects()
         MBProgressHUD.showAdded(to: view, animated: true)
        let url : URL  = URL(string : BASE_URL + CATEGORY )!
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success:
                if let dictionary = response.result.value as? [String : AnyObject]{
                    DispatchQueue.main.async {
                        self.listData = dictionary["data"] as! [[String : AnyObject]]
                            for i in 0...self.listData.count-1 {
                            let fod : FoodRestaurent = FoodRestaurent()
                            var foodRes = self.listData[i]
                            fod.foodID = (foodRes["id"] as? String)!
                            fod.foodImage = (foodRes["imageUrl"] as? String)!
                            fod.foodName = (foodRes["name"] as? String)!
                            self.listFood.add(fod)
                        }
                        if self.check == 0 {
                            self.listFoodAdd.removeAllObjects()
                            for i in 0...self.listFood.count-1 {
                                let fo = self.listFood.object(at: i) as! FoodRestaurent
                                self.listFoodAdd.add(fo)
                            }
                        } else {
                            for _ in 0...self.check-1 {
                                for j in 0...self.listFood.count-1 {
                                    let fo = self.listFood.object(at: j) as! FoodRestaurent
                                    self.listFoodAdd.add(fo)
                                }
                            }
                        }
                        self.tblView.refreshControl?.endRefreshing()
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (100 - tableView.bounds.size.height / 8) != 0.0 ? 100 : tableView.bounds.size.height / 8
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listFoodAdd.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodTableViewCell") as! FoodTableViewCell
        let food = self.listFoodAdd.object(at: indexPath.row) as! FoodRestaurent
        cell.imageFood.downloadedFrom(link: food.foodImage)
        cell.lblNameFood.text = food.foodName
        cell.selectionStyle = .none
        return cell
    }
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        let lastElement = self.listFoodAdd.count - 1
        if indexPath.row == lastElement {
           tblView.infiniteScrollingView.stopAnimating()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryVC = CategoryViewController()
        let food = self.listFoodAdd.object(at: indexPath.row) as! FoodRestaurent
        categoryVC.idFood = food.foodID
        categoryVC.tableNumber = self.tableNumber
        categoryVC.index = String(indexPath.row)
        categoryVC.listFood = self.listFood
    
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    @IBAction func onCart(_ sender: Any) {
        let cart = CartViewController()
        cart.tableNumber = self.tableNumber
        self.navigationController?.pushViewController(cart, animated: true)
    }
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

