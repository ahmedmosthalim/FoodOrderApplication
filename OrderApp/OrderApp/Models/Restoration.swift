//
//  Restoration.swift
//  OrderApp
//
//  Created by Ahmed Mostafa on 26/02/2022.
//

import Foundation

enum StateRestorationController {
   
    enum Identifier: String {
        case categories, menu, menuItemDetail, order
    }
    
    case categories
    case menu(category: String)
    case menuItemDetail(menuItem)
    case order
    
    var identifier: Identifier {
        switch self {
        case .categories: return Identifier.categories
        case .menu: return Identifier.menu
        case .menuItemDetail: return Identifier.menuItemDetail
        case .order: return Identifier.order
        }
    }
}

extension NSUserActivity {
    
    var order: Order? {
        get {
            guard let jsonData = userInfo?["order"] as? Data else {
                return nil
            }
            
            return try? JSONDecoder().decode(Order.self,
               from: jsonData)
        }
        set {
            if let newValue = newValue, let jsonData = try?
               JSONEncoder().encode(newValue) {
            addUserInfoEntries(from: ["order": jsonData])
            } else {
                userInfo?["order"] = nil
            }
        }
    }
}
