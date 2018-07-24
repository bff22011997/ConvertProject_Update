//
//  Support.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/11/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit

class Support: NSObject {
    func saveArrayObjectToUserDefault(array : NSArray , key : String) -> Void {
        let userDefault = UserDefaults.standard
        var data: Data? = nil
        data = NSKeyedArchiver.archivedData(withRootObject: array)
        userDefault.set(data, forKey: key)
        userDefault.synchronize()
    }
    func getArrayObjectFromNSUserDefault(key : String) -> NSArray {
        let userDefault = UserDefaults.standard
        let data = userDefault.object(forKey: key ) as? Data
        if data == nil {
            let array = NSArray()
            return array
        } else {
            return (NSKeyedUnarchiver.unarchiveObject(with: data!) as! NSArray)
        }
    }
    func formatterString(str : String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let groupingSeparator = Locale.current.groupingSeparator
        formatter.groupingSeparator = groupingSeparator
        formatter.groupingSize = 3
        formatter.alwaysShowsDecimalSeparator = false
        formatter.usesGroupingSeparator = true
        let formattedString = formatter.string(from: Int(str)! as NSNumber)
        return formattedString!
    }
}
