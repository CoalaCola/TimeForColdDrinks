//
//  yourOrderTableViewController.swift
//  TimeForColdDrinks
//
//  Created by Vince Lee on 2017/8/29.
//  Copyright © 2017年 Vince Lee. All rights reserved.
//

import UIKit
import Firebase

class yourOrderTableViewController: UITableViewController {
    
    //    var order: [String] = []
    var order = Order()
    var ref: DatabaseReference!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sugarSegment: UISegmentedControl!
    @IBOutlet weak var iceSegment: UISegmentedControl!
    
    
    @IBAction func sugarSegmentIndexChanged(_ sender: UISegmentedControl) {
        
        order.sugar = sender.titleForSegment(at: sugarSegment.selectedSegmentIndex)
        
        
    }
    
    @IBAction func iceSegmentIndexChanged(_ sender: UISegmentedControl) {
        order.ice = sender.titleForSegment(at: iceSegment.selectedSegmentIndex)
        
    }
    
    @IBAction func orderSaveButton(_ sender: Any) {
        
        let doubleCheck = UIAlertController(title: order.drinkName, message: "Are you sure to order?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let sure = UIAlertAction(title: "Sure", style: .default) { (sure) in
            self.uploadOrderToList()
            
            self.tabBarController?.selectedIndex = 1
        }
        doubleCheck.addAction(cancel)
        doubleCheck.addAction(sure)
        present(doubleCheck, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        fetchName()
        
        nameLabel.text = order.name
        drinkNameLabel.text = order.drinkName
        priceLabel.text = "$\(order.price!)"
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func uploadOrderToList() {
        let value: [String: String] = ["name": order.name!, "drinkName": order.drinkName!, "price": order.price!, "sugar": order.sugar!, "ice": order.ice!]
        let uid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference()
        
        
        // fetch Drink Number
        var drinkNumber: Int?
       ref.child("orderList").observeSingleEvent(of: .value, with: { snapshot in
            var newOrders = [Order]()
            for i in snapshot.children {
                if let dataSnapshot = i as? DataSnapshot
                {
                let order = Order(snapshot: dataSnapshot)
                newOrders.append(order)
                }
            }
            drinkNumber = newOrders.count
            print(drinkNumber!)
        }
            
        )
        
        let orderList = ref.child("orderList")
        orderList.child(uid!).setValue(value)
        
        
        
        let updateUserDrink = ref.child("users").child(uid!)
        updateUserDrink.updateChildValues(value, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        })
    }
    
    
    
    /*
     func fetchName() {
     var nameInOnlineData: String?
     ref = Database.database().reference()
     
     ref.child("users").observeSingleEvent(of: .value, with: { snapshot in
     if let snapshotValue = snapshot.value as? [String: String] {
     nameInOnlineData = snapshotValue["name"]
     
     }
     DispatchQueue.main.async {
     self.order.name = nameInOnlineData
     self.tableView.reloadData()
     }
     
     }) { (error) in
     print(error.localizedDescription)
     }
     }
     */
    
}

/*
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
 
 // Configure the cell...
 
 return cell
 }
 */

/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


