//
//  Extensions.swift
//  Haystek
//
//  Created by Tirumala on 01/04/25.
//

import Foundation
import UIKit

struct URLConstant {
    
    //static let BASEURL = "http://192.168.1.46:5001"
    static let BASEURL = "https://fakestoreapi.com/"
    
    struct Client {
        static let device = BASEURL + "products"
    }
}
struct ApiResponse:Codable{
let id: Int
 let title: String
 let price: Double
 let description: String
 let category: Category
 let image: String?
 let rating: Rating
}

enum Category: String, Codable {
 case electronics = "electronics"
 case jewelery = "jewelery"
 case menSClothing = "men's clothing"
 case womenSClothing = "women's clothing"
}

// MARK: - Rating
struct Rating: Codable {
 let rate: Double
 let count: Int
}

typealias Welcome = [ApiResponse]

class ApiService {
    
    // Define the function with an escaping closure to handle the response
    func fetchData(completion: @escaping (Result<[ApiResponse], Error>) -> Void) {
        
        // Example URL (replace with your actual API URL)
        let url = URL(string: URLConstant.Client.device)!
        
        // Create a URLSession data task to fetch data
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Check if there is an error
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check if the response data exists
            guard let data = data else {
                let error = NSError(domain: "ApiService", code: 100, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            // Try to decode the JSON response into the ApiResponseWrapper struct
            do {
                let decodedResponse = try JSONDecoder().decode(Welcome.self, from: data)
                completion(.success(decodedResponse)) // Send decoded array of devices in the completion handler
            } catch let decodingError {
                completion(.failure(decodingError))
            }
            
        }.resume() // Start the data task
    }

}

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                } else {
                    // Handle error if necessary
                    print("Error fetching image: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
            task.resume()
        }
    }
}

extension UILabel {

func strikeThrough(_ isStrikeThrough:Bool) {
    if isStrikeThrough {
        if let lblText = self.text {
            let attributeString =  NSMutableAttributedString(string: lblText)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
            self.attributedText = attributeString
        }
    } else {
        if let attributedStringText = self.attributedText {
            let txt = attributedStringText.string
            self.attributedText = nil
            self.text = txt
            return
        }
    }
    }
}
