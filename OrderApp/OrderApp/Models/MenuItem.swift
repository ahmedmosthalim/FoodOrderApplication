//
//  MenuItem.swift
//  OrderApp
//
//  Created by Ahmed Mostafa on 25/02/2022.
//

import Foundation
struct menuItem: Codable {
    let category: String
    let id: Int
    let imageURL: URL
    let name, itemDescription: String
    let price: Double

    enum CodingKeys: String, CodingKey {
        case category, id
        case imageURL = "image_url"
        case name
        case itemDescription = "description"
        case price
    }

//    init(category: String?, id: Int?, imageURL: String?, name: String?, itemDescription: String?, price: Double?) {
//        self.category = category
//        self.id = id
//        self.imageURL = imageURL
//        self.name = name
//        self.itemDescription = itemDescription
//        self.price = price
//    }
}
