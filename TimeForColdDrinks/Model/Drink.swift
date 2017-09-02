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
    
    init() {
//        var ref: DatabaseReference!
//        let uid = Auth.auth().currentUser?.uid
//        ref = Database.database().reference()
//        var newName: String?
//        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
//            if let snapshotValue = snapshot.value as? [String: String] {
//                newName = snapshotValue["name"]
//
//            }
//            DispatchQueue.main.async {
//                self.name = newName
//            }
//        })
        
        
//        name = newName
        
        name = Auth.auth().currentUser?.displayName
        drinkName = nil
        price = nil
        sugar = "100%"
        ice = "100%"
    }
    
    init(snapshot: DataSnapshot) {
        
        if let snapshotValue = snapshot.value as? [String: String] {
        name = (snapshotValue["name"])!
        drinkName = (snapshotValue["drinkName"])!
        price = (snapshotValue["price"])!
        sugar = (snapshotValue["sugar"])!
        ice = (snapshotValue["ice"])!
        
        } else {
            print("Order init snapshot failed")
        }
    }
}

struct PropertyKeys {
    static let loginToMenuSegue = "LoginToMenu"
    static let drinkList = "DrinkList"
    static let orderListCell = "OrderListCell"
}
