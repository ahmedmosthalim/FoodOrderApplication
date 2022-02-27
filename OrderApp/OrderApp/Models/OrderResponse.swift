//
//  OrderResponse.swift
//  OrderApp
//
//  Created by Ahmed Mostafa on 25/02/2022.
//

import Foundation

struct OrderResponse : Codable
{
    let prepTime : Int
    
    
    enum CodingKeys : String ,CodingKey {
        case prepTime = "preparation_time"
    }
}
