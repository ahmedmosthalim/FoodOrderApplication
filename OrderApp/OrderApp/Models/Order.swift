//
//  Order.swift
//  OrderApp
//
//  Created by Ahmed Mostafa on 25/02/2022.
//

import Foundation

struct Order : Codable
{
    var menuItmes : [menuItem]
    
    init(menuItems : [menuItem] = []){
        self.menuItmes = menuItems
    }
}

