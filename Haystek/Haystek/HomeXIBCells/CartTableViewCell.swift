//
//  CartTableViewCell.swift
//  Haystek
//
//  Created by Tirumala on 01/04/25.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profilecartImg: UIImageView!
    
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBOutlet weak var cartItemLbl: UILabel!
    
    @IBOutlet weak var stepperLbl: UILabel!
    
    @IBOutlet weak var cartStepperLbl: UIStepper!
    @IBOutlet weak var priceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
