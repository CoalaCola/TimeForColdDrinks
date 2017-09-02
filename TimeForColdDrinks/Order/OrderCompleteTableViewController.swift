//
//  OrderCompleteTableViewController.swift
//  TimeForColdDrinks
//
//  Created by Vince Lee on 2017/8/31.
//  Copyright © 2017年 Vince Lee. All rights reserved.
//

import UIKit
import Firebase


class OrderCompleteTableViewController: UITableViewController {

    var completeOrder = Order()
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var iceLabel: UILabel!
   
    @IBAction func logoutButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchCompleteOrder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func fetchCompleteOrder() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
            
            if let snapshotValue = snapshot.value as? [String: String] {
            self.nameLabel.text = snapshotValue["name"]
            self.drinkNameLabel.text = snapshotValue["drinkName"]
            if let price = snapshotValue["price"] {
                self.priceLabel.text = "$\(price)"
            } else {
                self.priceLabel.text = ""
                }
            self.sugarLabel.text = snapshotValue["sugar"]
            self.iceLabel.text = snapshotValue["ice"]
            }
//            }
//            DispatchQueue.main.async {
////                self.drinks = newDrinks
////                self.tableView.reloadData()
//            }

        }) { (error) in
            print(error.localizedDescription)
        }
    }
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


