

import Foundation
import UIKit

class MenuController
{
    static let  orderUpdatedNotification = Notification.Name("MenuContoller.orderUpdated")
    static let shared = MenuController()
    var userActivity = NSUserActivity(activityType:"com.example.OrderApp.order")
    
    
    var order = Order(){
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
            userActivity.order = order
            
        }
    }
    let baseURL = URL(string: "http://localhost:8080/")!
    typealias MinutesToPrepare = Int
    
    func fetchCategories(completion: @escaping (Result<[String],Error>)->Void)
    {
        let categoriesUrl = baseURL.appendingPathComponent("categories")
        let task = URLSession.shared.dataTask(with: categoriesUrl){
            (data, response,error)in
            if let data = data {
            do{
            
                let jsonDecoder = JSONDecoder()
                let categoriesResponse = try jsonDecoder.decode(CategoriesResponse.self, from: data)
                completion(.success(categoriesResponse.categories))
            }catch
            {
                completion(.failure(error))
            }
            }else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func fetchMenuItems(forCategory categoryName : String,completion: @escaping (Result<[menuItem],Error>)->Void)
    {
        let baseMenusUrl = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url:baseMenusUrl,resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuUrl = components.url!
        let task = URLSession.shared.dataTask(with: menuUrl){
            (data, response,error)in
            if let data = data {
            do{
            
                let jsonDecoder = JSONDecoder()
                let menuResponse = try jsonDecoder.decode(MenuResponse.self, from: data)
                completion(.success(menuResponse.items))
            }catch
            {
                completion(.failure(error))
            }
            }else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    
    func submitOrder(forMenuIDs menuIDs:[Int],completion: @escaping (Result<Int,Error>)->Void)
    {
        let orderUrl = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderUrl)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = ["menuIds" :menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request){
            (data, response,error)in
            if let data = data {
            do{
            
                let jsonDecoder = JSONDecoder()
                let orderResponse = try jsonDecoder.decode(OrderResponse.self, from: data)
                completion(.success(orderResponse.prepTime))
            }catch
            {
                print("Here in catch")
                print(error)
                
                completion(.failure(error))
            }
            }else if let error = error {
                completion(.failure(error))
                print("Here in else if")
                print(error)
            }
        }
        task.resume()
    }
    func fetchImage(url : URL , complation: @escaping (UIImage?)-> Void)
    {
        let task = URLSession.shared.dataTask(with: url)
        {(data ,response,erorr) in
                if let data = data , let image = UIImage(data: data)
            {
                    complation(image)
            }else
            {
                complation(nil)
            }
        }
        task.resume()
    }
    
//    func updateUserActivity(with controller: StateRestorationController) {
//        switch controller {
//        case .menu(let category):
//            userActivity.menuCategory = category
//        case .menuItemDetail(let menuItem):
//            userActivity.menuItem = menuItem
//        case .order, .categories:
//            break
//        }
//
//        userActivity.controllerIdentifier = controller.identifier
//    }
}
