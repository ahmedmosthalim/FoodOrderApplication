//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by Ahmed Mostafa on 25/02/2022.
//

import UIKit

class MenuTableViewController: UITableViewController {

    let menuCotroller = MenuController()
    let category : String
    var menuItems = [menuItem]()

    
    
    init?(coder: NSCoder , category: String)
    {
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuCotroller.fetchMenuItems(forCategory: category) {
            (result) in
            switch result
            {
            case .success(let menuItem):
                self.updateUI(with : menuItem)
            case .failure(let error) :
                self.displayError(error,title : "Failed")
            }
        }
    }
    func updateUI(with menuItem : [menuItem])
    {
        DispatchQueue.main.async {
            self.menuItems = menuItem
            self.navigationItem.title = self.category.capitalized
            self.tableView.reloadData()
        }
    }
    func displayError(_ error:Error , title : String)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController (title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Menu", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row].name.capitalized
        cell.detailTextLabel?.text = "£ \(menuItems[indexPath.row].price)"
        MenuController.shared.fetchImage(url: menuItems[indexPath.row].imageURL)
        {
            (image)in
            guard let image = image else {
                return}
            DispatchQueue.main.async {
            cell.imageView?.image = image
            cell.setNeedsLayout()
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    @IBSegueAction func showMenuItem(_ coder: NSCoder, sender: Any?) -> MeniItemDetailViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell)
            else{
                return nil
            }
            let menuItem = menuItems[indexPath.row]
        return MeniItemDetailViewController(coder: coder,menuItem: menuItem)
    }
//    func configure (_ cell:UITableViewCell,forItemAt indexpath:IndexPath )
//    {
//        MenuController.shared.fetchImage(url: menuItems[indexpath.row].imageURL as! URL)
//        {
//            (image)in
//            guard let image = image else {
//                return}
//
//        }
//    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
