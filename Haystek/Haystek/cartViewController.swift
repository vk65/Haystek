//
//  cartViewController.swift
//  Haystek
//
//  Created by Tirumala on 01/04/25.
//

import UIKit

struct CartItem {
    var name: String
    var price: String
    var img:String
    var quantity: Int // Added quantity property

}


protocol CartUpdateDelegate: AnyObject {
    func didUpdateCart(cartItems: [CartItem])
}
class cartViewController: UIViewController {
    
    


        @IBOutlet weak var tableView: UITableView!
        
    weak var delegate: CartUpdateDelegate?
       var cartItems = [CartItem]() {
           didSet {
               print(cartItems)
               // Reload data if the cartItems array is updated
               tableView?.reloadData()
           }
       }

        override func viewDidLoad() {
            super.viewDidLoad()
            if let cartVC = tabBarController?.viewControllers?.first(where: { $0 is cartViewController }) as? cartViewController {
                cartVC.delegate = self // Set the current view controller as the delegate
            }
            // Set the table view delegate and data source
            tableView.delegate = self
            tableView.dataSource = self
            let nib = UINib(nibName: "CartTableViewCell", bundle: nil)
            // Register the table view cell
            tableView.register(nib, forCellReuseIdentifier: "CartTableViewCell")
            
        }
    
  
        
        // Add item to cart
        @IBAction func addItemToCart(_ sender: UIBarButtonItem) {
            let newItem = CartItem(name: "Item \(cartItems[0].name)", price: cartItems[0].price, img: cartItems[0].img ?? "", quantity: 1)
            cartItems.append(newItem)
            tableView.reloadData()
        }
        
        // Delete item from cart
        func deleteItem(at index: Int) {
            cartItems.remove(at: index)
            tableView.reloadData()
        }
    }

    extension cartViewController: UITableViewDelegate, UITableViewDataSource {
        
        // Number of rows in table view
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return cartItems.count
        }
        
        // Configure the cell for each cart item
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
            
            let item = cartItems[indexPath.row]
            cell.cartItemLbl?.text = "\(item.name)"
            cell.priceLbl?.text =  "$\(item.price)"
            if let urlString:String? = item.img, let url = URL(string: urlString ?? "") {
                cell.profilecartImg.imageFromUrl(urlString: urlString ?? "")
            } else {
                // Handle the case where the URL is nil or invalid
            }
            // Set up stepper for quantity control
               cell.cartStepperLbl.minimumValue = 1
            cell.stepperLbl.text = "\(item.quantity)"
               cell.cartStepperLbl.value = Double(item.quantity)
               cell.cartStepperLbl.tag = indexPath.row // Set the tag to identify the correct item
               cell.cartStepperLbl.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)

               return cell
                    
            
        }
        
        
        
        @objc func stepperValueChanged(_ sender: UIStepper) {
            let index = sender.tag
            let newQuantity = Int(sender.value)
            
            // Update the cart item quantity
            cartItems[index].quantity = newQuantity

            // Update the data and reload the specific row to reflect the change
            let indexPath = IndexPath(row: index, section: 0)
            
            // Reload the specific row
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
            // Append the new quantity to the label in the updated cell
            if let cell = tableView.cellForRow(at: indexPath) as? CartTableViewCell {
                // Assuming the label to append the quantity is named 'quantityLbl'
                cell.stepperLbl.text = " \(newQuantity)"  // Modify as per your label's design
            }
        }


        // Allow item deletion when swiped
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                deleteItem(at: indexPath.row)
            }
        }
        
        // Handle row selection (optional - this can be used to view cart item details, etc.)
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let item = cartItems[indexPath.row]
            print("Selected item: \(item.name) - $\(item.price)")
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }


extension cartViewController: CartUpdateDelegate {
    func didUpdateCart(cartItems: [CartItem]) {
        // Update the cartItems array with the new data
        self.cartItems = cartItems

        // Reload the table view
        tableView.reloadData()
    }
}
