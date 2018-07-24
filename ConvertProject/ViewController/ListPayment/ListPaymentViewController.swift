//
//  ListPaymentViewController.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/20/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit

class ListPaymentViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tblView: UITableView!
    var listPayment = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate = self
        tblView.register(UINib.init(nibName: "ListPaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "ListPaymentTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let s = Support()
        let arr : NSArray =  s.getArrayObjectFromNSUserDefault(key: "listPayment")
        listPayment = NSMutableArray.init(array: arr)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPayment.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListPaymentTableViewCell") as! ListPaymentTableViewCell
        let his = listPayment.object(at: indexPath.row) as! History
        cell.lblDate.text = his.date
        cell.lblPrice.text = his.price
        cell.lblTable.text = his.table
        cell.selectionStyle = .none
        return cell
    }
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
