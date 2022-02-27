//
//  CategoryTableViewController.swift
//  OrderApp
//
//  Created by Ahmed Mostafa on 25/02/2022.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    let menuCotroller = MenuController()
    var categories = [String]()
    let images = ["appetizers","salads","soups","entrees","desserts","sandwiches"]

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Restaurant"
        self.menuCotroller.fetchCategories {
            (result) in
            switch result
            {
            case .success(let catogeries):
                self.updateUI(with : catogeries)
            case .failure(let error) :
                self.displayError(error,title : "Failed")
            }
        }
    }
        func updateUI(with categories : [String])
        {
            DispatchQueue.main.async {
                self.categories = categories
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
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath) 
        
        cell.textLabel?.text = categories[indexPath.row].capitalized
        cell.imageView?.image = UIImage(named: images[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    @IBSegueAction func showMenu(_ coder: NSCoder, sender: Any?) -> MenuTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell)
        else{
            return nil
        }
        let category = categories[indexPath.row]
                
        return MenuTableViewController(coder: coder,category: category)
    }
    

    /*    // Override to support editing the table view.
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
