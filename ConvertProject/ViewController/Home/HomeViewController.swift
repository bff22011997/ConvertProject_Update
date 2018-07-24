//
//  HomeViewController.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/9/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var collectionView: UICollectionView!
    
    var listTable : NSMutableArray = NSMutableArray()
    var check : Int = 0
    var listTableAddData =  NSMutableArray()
    var listData : [[String : AnyObject]] = [[String : AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addPullToRefresh {
            self.insertRowAtTop()
        }
        collectionView.addInfiniteScrolling {
            self.insertRowAtBottom()
        }
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getDataFromAPI()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if collectionView.refreshControl?.isRefreshing != nil {
            refresh()
        }
    }
    
    func refresh() {
        collectionView.refreshControl?.endRefreshing()
        collectionView.reloadData()
    }
    func insertRowAtTop() {
        check = 0
        self.getDataFromAPI()
    }
    func insertRowAtBottom() {
        check = check + 1
        self.getDataFromAPI()
        collectionView.infiniteScrollingView.stopAnimating()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listTableAddData.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: (collectionView.frame.size.width - 30) / 3, height: (collectionView.frame.size.width - 30) / 3 - 20)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let tableRes  =  self.listTableAddData.object(at: indexPath.row) as! TableRestaurent
        cell.lblTable.text = tableRes.tableID
        let checkStatus : Int = Int(tableRes.tableStatus)!
        if checkStatus == 1 {
            cell.imageView.image = UIImage.init(named: "table_select.png")
            cell.lblTable.textColor = UIColor.red
        } else {
            cell.imageView.image = UIImage.init(named: "table_not_select.png")
            cell.lblTable.textColor = UIColor.lightGray
        }
        return cell
    }
    func getDataFromAPI() -> Void {
        self.listTable.removeAllObjects()
        MBProgressHUD.showAdded(to: view, animated: true)
        let url : URL  = URL(string : BASE_URL + ALL_TABLES )!
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success:
                if let dictionary = response.result.value as? [String : AnyObject]{
                    DispatchQueue.main.async {
                        self.listData = dictionary["data"] as! [[String : AnyObject]]
                        for i in 0...self.listData.count-1 {
                            let tab : TableRestaurent = TableRestaurent()
                            let tableRes = self.listData[i]
                            tab.tableID = (tableRes["id"] as? String)!
                            tab.tableOperatorId = String((tableRes["operatorId"] as? Int)!)
                            tab.tableStatus = String((tableRes["status"] as? Int)!)
                            self.listTable.add(tab)
                        }
                        if self.check == 0 {
                            self.listTableAddData.removeAllObjects()
                            for j in 0...self.listTable.count-1 {
                                let tbl = self.listTable.object(at: j) as! TableRestaurent
                                self.listTableAddData.add(tbl)
                            }
                        } else {
                            for  _ in 0...self.check-1 {
                                for j in 0...self.listTable.count-1 {
                                    let tbl = self.listTable.object(at: j) as! TableRestaurent
                                    self.listTableAddData.add(tbl)
                                }
                                
                            }
                        }
                        self.collectionView.refreshControl?.endRefreshing()
                        self.collectionView.reloadData()
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: (true))
                    }
                    
                }
                break
            case .failure(_):
                print(Error.self)
                 MBProgressHUD.hideAllHUDs(for: self.view, animated: (true))
                self.collectionView.refreshControl?.endRefreshing()
                
            }
        }

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let foodVC = FoodViewController()
        let tableRes  = self.listTableAddData.object(at: indexPath.row) as! TableRestaurent
        foodVC.tableNumber = tableRes.tableID
        self.navigationController?.pushViewController(foodVC, animated: true)
    }
    @IBAction func onMenu(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
