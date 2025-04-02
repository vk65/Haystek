//
//  ViewController.swift
//  Haystek
//
//  Created by Tirumala on 01/04/25.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate {
    let data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    var cartItems: [CartItem] = [] // Array to hold cart items
    @IBOutlet weak var homeCollectionView:UICollectionView!
    let apiService = ApiService()
    weak var delegate: CartUpdateDelegate?
    var searchActive:Bool = false
    @IBOutlet weak var searchBar: UISearchBar!
    var responseArr = [ApiResponse]()
    override func viewDidLoad() {
        super.viewDidLoad()
        homeCollectionView.register(UINib(nibName: "SectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)

        let tabBarControllerItems = self.tabBarController?.tabBar.items

        self.tabBarController?.tabBar.items?[1].isEnabled=false


        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        let nib1 = UINib(nibName: "FlasgCollectionViewCell", bundle: nil)
        homeCollectionView.register(nib, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        homeCollectionView.register(nib1, forCellWithReuseIdentifier: "FlasgCollectionViewCell")
       
        let customLasyout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        customLasyout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        customLasyout.minimumInteritemSpacing = 0
        customLasyout.scrollDirection = .horizontal  // Items will be in a single horizontal row
        // Set item size (width, height)
              let itemWidth = view.frame.width / 3 - 10  // Adjust width based on your design
        customLasyout.itemSize = CGSize(width: itemWidth, height: 200) // Set item height
        customLasyout.minimumLineSpacing = 10  // Space between items in the row
        customLasyout.minimumInteritemSpacing = 0 // No spacing between items vertically
        
        homeCollectionView!.collectionViewLayout = customLasyout
    
        
        self.tabBarController?.tabBar.isHidden = false
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        homeCollectionView!.collectionViewLayout = layout
       logincheckUser()
        searchBar.delegate = self // and it's important too

        // Do any additional setup after loading the view.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
        {
            searchActive = false
            self.searchBar.endEditing(true)
        }
    
    func logincheckUser(){
        // Example URL
        apiService.fetchData { result in
            switch result {
            case .success(let response):
                // Handle the successful response
                //print("ID: \(response.id), Name: \(response.title)")
                DispatchQueue.main.async {
                    self.responseArr.removeAll()
                    self.responseArr.append(contentsOf: response)
                    self.homeCollectionView.delegate = self
                    self.homeCollectionView.dataSource = self
                    self.homeCollectionView.reloadData()
                }
            case .failure(let error):
                // Handle the error
                print("Error: \(error.localizedDescription)")
            }
        }
    }


}
extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return data.count
        }else{
            return responseArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            cell.categoryLbl.text = "\(data[indexPath.row])"
            cell.categoryImg.image = UIImage(named: "pic")
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlasgCollectionViewCell", for: indexPath) as! FlasgCollectionViewCell
            
            
            if indexPath.item < responseArr.count {
                if let urlString = responseArr[indexPath.item].image, let url = URL(string: urlString) {
                    cell.flashImage.imageFromUrl(urlString: urlString)
                } else {
                    // Handle the case where the URL is nil or invalid
                    cell.flashImage.image = UIImage(named: "placeholder") // Or handle this case accordingly
                }
            } else {
                // Handle the case where indexPath.item is out of range
                cell.flashImage.image = UIImage(named: "placeholder")
            }
            cell.cartBtn.addTarget(self, action: #selector(stepperValueChanged(_:)), for: UIControl.Event.touchUpInside)
            cell.flashLbl.text = responseArr[indexPath.item].title
            cell.currentPriceLbl.text = "$ \(responseArr[indexPath.item].price)"
            cell.crossLabel.text = "$ \("125")"
            cell.crossLabel.strikeThrough(true)
            return cell
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
       {
           
           if indexPath.section == 0{
           return CGSize(width: 100, height: 100)
           }else{
               let leftAndRightPaddings: CGFloat = 45.0
               let numberOfItemsPerRow: CGFloat = 2.0
               
               let width = (collectionView.frame.width-leftAndRightPaddings)/numberOfItemsPerRow
               return CGSize(width: width, height: 300) // You can change width and height here as pr your requirement
           }
       
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DescViewController") as! DescViewController
        vc.imagesrt = responseArr[indexPath.item].image
        vc.itemStr = responseArr[indexPath.item].title ?? ""
        vc.descStr = responseArr[indexPath.item].description ?? ""
        vc.priceStr = "\(responseArr[indexPath.item].price ?? 0.0)"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           switch section {
           case 0:
               return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Insets for horizontal section
           case 1:
               return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0) // Insets for vertical section
           default:
               return UIEdgeInsets.zero
           }
       }
    
    // UICollectionViewDataSource methods

       // UICollectionViewDelegateFlowLayout methods
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
           return CGSize(width: homeCollectionView.frame.size.width, height: 50)
       }

       // UICollectionViewDataSource method for supplementary views (headers)
       func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
           if kind == UICollectionView.elementKindSectionHeader {
               let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
               headerView.backgroundColor = .white
               if indexPath.section == 0{
                   headerView.categoriesLbl.text = "Categories"
                   headerView.flashLbl.isHidden = true
               }else{
                   headerView.categoriesLbl.text = "Flash Sale"
                   headerView.flashLbl.isHidden = false
               }
               return headerView
           }
           return UICollectionReusableView()
       }
    
//    @objc func stepperValueChanged(_ sender: UIButton) {
//        let index = sender.tag
//        let newItem = CartItem(name: "\(responseArr[index].title ?? "")", price: "\(responseArr[index].price  ?? 0.0)", img: responseArr[index].image ?? "", quantity: 1)
//
//               // Append the new item to cartItems
//
//print(newItem)
//        if let cartVC = tabBarController?.viewControllers?.first(where: { $0 is cartViewController }) as? cartViewController {
//                    cartVC.delegate?.didUpdateCart(cartItems: [newItem])
//                }
//
//        // Update the data and reload the specific row to reflect the change
//        let indexPath = IndexPath(row: index, section: 0)
//        let vc = cartViewController()
//        vc.cartItems = cartItems  // Pass data
//        // Reload the specific row
//        vc.tableView?.reloadRows(at: [indexPath], with: .automatic)
//
//        // Append the new quantity to the label in the updated cell
//
//    }
    
    @objc func stepperValueChanged(_ sender: UIButton) {
        let index = sender.tag
        let newItem = CartItem(name: "\(responseArr[index].title ?? "")", price: "\(responseArr[index].price ?? 0.0)", img: responseArr[index].image ?? "", quantity: 1)
        
       // print(newItem)

        // Append the new item to cartItems
      //  cartItems.append(newItem)  // Add the item to the cartItems array
        let indexPath = IndexPath(row: index, section: 0)

        // Notify the cartViewController that the cart has been updated
        if let cartVC = tabBarController?.viewControllers?.first(where: { $0 is cartViewController }) as? cartViewController {
            cartVC.delegate?.didUpdateCart(cartItems: [newItem])
            cartVC.cartItems = [newItem]
            cartVC.tableView?.reloadRows(at: [indexPath], with: .automatic)
            print(cartVC.cartItems)
        }

        // Update the data and reload the specific row to reflect the change
        let vc = cartViewController()  // Create a new cartVC instance
        vc.cartItems = cartItems  // Pass the updated cartItems to the new cartVC instance

        // Reload the specific row
//        vc.tableView?.reloadRows(at: [indexPath], with: .automatic)
    }

}



  private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
      if section == 0 {
        // item
        let item = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/5),
            heightDimension: .fractionalHeight(1)
          )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
                
        // group
        let group = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(140)
          ),
          subitem: item,
          count: 5
        )
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
                
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                
        // return
        return section
                
      }
      return nil
    }
  }

class TabVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func disableTabBar(itemNo: Int) {
        if let items = tabBar.items, itemNo < items.count {
            items[itemNo].isEnabled = false
        }
    }
}
