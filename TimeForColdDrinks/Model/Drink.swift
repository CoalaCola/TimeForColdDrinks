//
//  Model.swift
//  TimeForColdDrinks
//
//  Created by Vince Lee on 2017/8/29.
//  Copyright © 2017年 Vince Lee. All rights reserved.
//

import Foundation
import Firebase

class User: NSObject {
    var drinkName: String?
    var sugar:String?
    var ice:String?
    var price:Int?
    var name:String?
    var email:String?
    var password:String?
    var photoUrl:String?
    var uid:String?
    
}



struct Drink {
    
    let drinkName: String
    let price: String
    //    let sugar:String?
    //    let ice:String?
    
    
    init(drinkName: String, price: String ) {
        self.drinkName = drinkName
        self.price = price
        //        self.sugar = nil
        //        self.ice = nil
    }
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String]
        drinkName = snapshotValue[0]
        price = snapshotValue[1]
        
        
    }
}

struct Order {
    var name:String?
    var drinkName: String?
    var price:String?
    var sugar:String?
    var ice:String?
    
    init(dictionary: [String: AnyObject]) {
        
        
        name = dictionary["name"] as? String
        drinkName = dictionary["drinkName"] as? String
        price = dictionary["price"] as? String
        sugar = dictionary["sugar"] as? String
        ice = dictionary["ice"] as? String
    }
}

struct PropertyKeys {
    static let loginToMenuSegue = "LoginToMenu"
    static let drinkList = "DrinkList"
}
