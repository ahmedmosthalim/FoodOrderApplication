//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Ahmed Mostafa on 26/02/2022.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    @IBOutlet weak var confirmationLabel: UILabel!
    

//        if segue.identifier == "dismissConfirmation"
//        {
//            MenuController.shared.order.menuItmes.removeAll()
//
       
        
    let minutesToPrepareOrder :Int
    init?(coder: NSCoder ,minutesToPrepare : Int)
    {
        self.minutesToPrepareOrder = minutesToPrepare
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        confirmationLabel.text = "Thank You for Your Order , Your Wait Time Is Approximately \(minutesToPrepareOrder) minutes"
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
