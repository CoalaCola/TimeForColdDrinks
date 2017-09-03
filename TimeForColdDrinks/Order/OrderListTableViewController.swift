//
//  orderListTableViewController.swift
//  TimeForColdDrinks
//
//  Created by Vince Lee on 2017/8/29.
//  Copyright © 2017年 Vince Lee. All rights reserved.
//

import UIKit
import Firebase

class orderListTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    var orders = [Order]()
    var allUid = [String]()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var drinkNameLabel: NSLayoutConstraint!
    
    @IBOutlet weak var sugarLabel: UILabel!
    
    @IBOutlet weak var iceLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    @IBAction func refreshButton(_ sender: Any) {
        self.viewWillAppear(true)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllDrinkOrdersUid { (newAllUid) in
            print("complete fetch")
            self.allUid = newAllUid
            print(self.allUid)
            self.viewWillAppear(true)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    }
        
    override func viewWillAppear(_ animated: Bool) {
        
        
        fetchOrderList()
        self.tableView.reloadData()
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func fetchOrderList() {
        ref = Database.database().reference()
        var newOrders = [Order]()
        for uid in allUid {
            ref.child("orderList").child(uid).observeSingleEvent(of: .value, with: { snapshot in
                
                if (snapshot.value as? [String: String]) != nil {
                   DispatchQueue.main.async {
                    let order = Order(snapshot: snapshot)
                        newOrders.append(order)
                    self.orders = newOrders
                    self.tableView.reloadData()
                    }
                    
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchAllDrinkOrdersUid(completion: @escaping ([String]) -> ()) {
        var newAllUid = [String]()
        ref = Database.database().reference()
        ref.child("orderList").observe(.value, with: { (snapshot) in
            newAllUid = []
            for uid in snapshot.children {
                if let uid = uid as? DataSnapshot {
                    DispatchQueue.main.async {
                        newAllUid.append(uid.key)
                        print(newAllUid)
                        completion(newAllUid)
                    }          
                }
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> OrderListTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.orderListCell, for: indexPath)
        
        // Configure the cell...
        configure(cell: cell as! OrderListTableViewCell, forItemAt: indexPath)
        
        
        return cell as! OrderListTableViewCell
    }
    func configure(cell: OrderListTableViewCell, forItemAt indexPath: IndexPath) {
        let order = orders[indexPath.row]
        cell.nameLabel?.text = order.name
        cell.priceLabel?.text = "$\(order.price!)"
        cell.drinkNameLabel?.text = order.drinkName
        cell.sugarLabel?.text = "Sugar: \(order.sugar!)"
        cell.iceLabel?.text = "Ice: \(order.ice!)"
        
    }
    
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
    
}
