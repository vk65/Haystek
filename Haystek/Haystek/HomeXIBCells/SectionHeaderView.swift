//
//  SectionHeaderView.swift
//  Haystek
//
//  Created by Tirumala on 02/04/25.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"

    
    @IBOutlet weak var categoriesLbl: UILabel!
    
    
    @IBOutlet weak var flashLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
