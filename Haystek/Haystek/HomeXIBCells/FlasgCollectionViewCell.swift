//
//  FlasgCollectionViewCell.swift
//  Haystek
//
//  Created by Tirumala on 01/04/25.
//

import UIKit

class FlasgCollectionViewCell: UICollectionViewCell {
    
   
    
    @IBOutlet weak var cartBtn: UIButton!
    
    @IBOutlet weak var flashImage: UIImageView!
    
    
    @IBOutlet weak var flashLbl: UILabel!
    
    @IBOutlet weak var currentPriceLbl: UILabel!
    
    
    @IBOutlet weak var crossLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    // Example UI elements like a label and image view
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Add and constrain the label
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // Configure the cell with data
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    
    
    
}
