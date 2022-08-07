//
//  Product.swift
//  prodza
//
//  Created by Luka Korica on 8/6/22.
//

import Foundation

struct Product: Codable, Hashable {
    let image_link: String
    let price: String
    let name: String
    let brand: String
    let description: String
    let category: String?
    let product_type: String
    let product_colors: [Color]
    
    
    init(name: String, brand: String, price: String, image_link: String, description: String, category: String?, product_type: String, product_colors: [Color]){
        self.name = name
        self.price = price
        self.brand = brand
        self.image_link = image_link
        self.description = description
        self.category = category
        self.product_type = product_type
        self.product_colors = product_colors
    }
    
    
}

struct Color: Codable, Hashable {
    let hex_value: String
    let colour_name: String?
    
}
