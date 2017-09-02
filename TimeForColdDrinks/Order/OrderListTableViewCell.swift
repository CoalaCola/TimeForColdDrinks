//
//  OrderListTableViewCell.swift
//  TimeForColdDrinks
//
//  Created by Vince Lee on 2017/8/31.
//  Copyright © 2017年 Vince Lee. All rights reserved.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var sugarLabel: UILabel!
    
    @IBOutlet weak var iceLabel: UILabel!
    
    @IBOutlet weak var drinkNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
