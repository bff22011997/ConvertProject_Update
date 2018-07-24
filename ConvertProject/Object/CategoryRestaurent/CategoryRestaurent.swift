//
//  CategoryRestaurent.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/11/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit

class CategoryRestaurent: NSObject , NSCoding {
    var IDCategory : String = ""
    var nameCategory : String = ""
    var codeCategory : String = ""
    var priceCategory : String = ""
    var numberNameCategory : String = ""
    var categoryId : String = ""
    var isSelected : Bool = false
    init(IDCategory: String, nameCategory: String, codeCategory: String,priceCategory : String , numberNameCategory : String , categoryId : String, isSelected : Bool) {
        self.IDCategory = IDCategory
        self.nameCategory = nameCategory
        self.priceCategory = priceCategory
        self.numberNameCategory = numberNameCategory
        self.categoryId = categoryId
        self.codeCategory = codeCategory
        self.isSelected = isSelected
        
    }
    required convenience init(coder aDecoder: NSCoder) {
        let IDCategory = aDecoder.decodeObject(forKey: "IDCategory") as! String
        let nameCategory = aDecoder.decodeObject(forKey: "nameCategory") as! String
        let priceCategory = aDecoder.decodeObject(forKey: "priceCategory") as! String
        let numberNameCategory = aDecoder.decodeObject(forKey: "numberNameCategory") as! String
        let categoryId = aDecoder.decodeObject(forKey: "categoryId") as! String
        let codeCategory = aDecoder.decodeObject(forKey: "codeCategory") as! String
        let isSelected = aDecoder.decodeBool(forKey: "isSelected")
        self.init(IDCategory: IDCategory, nameCategory: nameCategory, codeCategory: codeCategory, priceCategory : priceCategory ,numberNameCategory : numberNameCategory,categoryId : categoryId ,isSelected : isSelected)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(IDCategory, forKey: "IDCategory")
        aCoder.encode(nameCategory, forKey: "nameCategory")
        aCoder.encode(priceCategory, forKey: "priceCategory")
        aCoder.encode(numberNameCategory, forKey: "numberNameCategory")
        aCoder.encode(categoryId, forKey: "categoryId")
        aCoder.encode(codeCategory, forKey: "codeCategory")
        aCoder.encode(isSelected, forKey: "isSelected")
    }
}
