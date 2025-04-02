//
//  DescViewController.swift
//  Haystek
//
//  Created by Tirumala on 01/04/25.
//

import UIKit

class DescViewController: UIViewController {
    
    var imagesrt:String?
    
    var itemStr:String?
    
    var descStr:String?
    
    var priceStr:String?
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var itemLbl: UILabel!
    
    var cartItems: [CartItem] = []  // The cartItems array to hold items

    
    @IBOutlet weak var descLbl: UILabel!
    
    var pointerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let urlString = imagesrt, let url = URL(string: urlString) {
            profileImg.imageFromUrl(urlString: urlString)
        } else {
            // Handle the case where the URL is nil or invalid
            profileImg.image = UIImage(named: "placeholder") // Or handle this case accordingly
        }
        self.tabBarController?.tabBar.isHidden = true
        itemLbl.text  = itemStr
        itemLbl.textAlignment = .left
        itemLbl.numberOfLines = 0
        descLbl.text  = descStr
        descLbl.textAlignment = .left
        descLbl.numberOfLines = 0
        // Create and configure the scrollView
        
        
        
        
    }
    
    
    @IBAction func addCartBtnAction(_ sender: UIButton) {
        let newItem = CartItem(name: "\(itemStr ?? "")", price: priceStr  ?? "", img: imagesrt ?? "", quantity: 1)

               // Append the new item to cartItems
               cartItems.append(newItem)

               // Pass the cartItems array to the next view controller
        
        let cartVC = storyboard?.instantiateViewController(withIdentifier: "cartViewController") as! cartViewController
        cartVC.cartItems = cartItems  // Pass data
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
}
