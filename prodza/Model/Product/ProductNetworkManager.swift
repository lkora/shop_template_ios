//
//  ProductNetworkManager.swift
//  prodza
//
//  Created by Luka Korica on 8/6/22.
//

import Foundation

protocol ProductNetworkManagerDelegate {
    func didUpdateProducts(_ productNetworkManager: ProductNetworkManager, products: [Product])
    func didFailWithError(error: Error)
}

struct ProductNetworkManager {
    let urlString = "https://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline"
    
    var delegate: ProductNetworkManagerDelegate?
    
    func fetchProducts() {
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let products = self.parseJSON(safeData) {
                        self.delegate?.didUpdateProducts(self, products: products)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> [Product]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([Product].self, from: weatherData)
            var productList = [Product]()
            for productDecoded in decodedData {
                productList.append(Product(name: productDecoded.name,
                                           brand: productDecoded.brand.capitalized,
                                           price: productDecoded.price,
                                           image_link: productDecoded.image_link,
                                           description: productDecoded.description,
                                           category: productDecoded.category,
                                           product_type: productDecoded.product_type,
                                           product_colors: productDecoded.product_colors
                                          ))
                debugPrint(productDecoded.product_colors)
            }
            return productList
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
