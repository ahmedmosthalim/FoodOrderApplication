//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by Ahmed Mostafa on 25/02/2022.
//

import UIKit

class OrderTableViewController: UITableViewController {

    var order = Order()
    var minutesToPrepareOrder = 0
    
    override func viewDidLoad() {
        self.navigationItem.title = "Orders"
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = editButtonItem
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdatedNotification, object: nil)
    
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return  1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MenuController.shared.order.menuItmes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        cell.textLabel?.text = MenuController.shared.order.menuItmes[indexPath.row].name
        cell.detailTextLabel?.text = "£\(MenuController.shared.order.menuItmes[indexPath.row].price)"
        MenuController.shared.fetchImage(url: MenuController.shared.order.menuItmes[indexPath.row].imageURL)
        {
            (image)in
            guard let image = image else {
                return}
            DispatchQueue.main.async {
            cell.imageView?.image = image
            cell.setNeedsLayout()
            }
        }
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            MenuController.shared.order.menuItmes.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
           
        }
    }
    
    @IBSegueAction func confirmOrder(_ coder: NSCoder, sender: Any?) -> OrderConfirmationViewController? {
        return OrderConfirmationViewController(coder: coder,minutesToPrepare: minutesToPrepareOrder )
    }
    
    @IBAction func submitTapped(_ sender: UIButton) {
    let orderTotal = MenuController.shared.order.menuItmes.reduce(0.0)
    {
        (result ,menuItem) -> Double in
        return result + menuItem.price
        
    }
    let alertController = UIAlertController(title: "Confirm Order", message: "You are about to submit order with a total of \(orderTotal)£", preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: {_ in self.uploadOrder()}))
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(alertController, animated: true, completion: nil)
    }
    
  
    
    func uploadOrder()
    {
        let menuIds : [Int] = MenuController.shared.order.menuItmes.map{ $0.id }
        MenuController.shared.submitOrder(forMenuIDs:menuIds)
        { (result) in
            switch result
            {
            case.success(let minutesToPrepare) :
                DispatchQueue.main.async {
                    self.minutesToPrepareOrder = minutesToPrepare
                    self.performSegue(withIdentifier: "confirmOrder", sender: nil)
                    
                }
            case .failure(let error) :
                self.displayError(error, title: "Order Submission Failed")
            }
            
        }
    }
    func displayError(_ error:Error, title:String)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil) )
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func unwindToOrderList(segue : UIStoryboardSegue)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Are You Sure To Cancel Order", message: "all Orders Will Be Deleted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
                if segue.identifier == "dismissConfirmation"
                {
                    MenuController.shared.order.menuItmes.removeAll()
        
                }}))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil) )
            self.present(alert, animated: true, completion: nil)
        }
        
                
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
