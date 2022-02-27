//
//  MeniItemDetailViewController.swift
//  OrderApp
//
//  Created by Ahmed Mostafa on 26/02/2022.
//

import UIKit
import CoreData

class MeniItemDetailViewController: UIViewController {

    let menuItem : menuItem
    @IBOutlet weak var wallPaper: UIImageView!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealPrice: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var addToOrderButton: UIButton!
    @IBOutlet weak var mealDesc: UILabel!
    var context = CIContext(options: nil)
    init?(coder: NSCoder , menuItem: menuItem)
    {
        self.menuItem = menuItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        self.navigationItem.title = menuItem.name

        mealName.text = menuItem.name
        mealDesc.text = menuItem.itemDescription
        mealPrice.text = "£\(menuItem.price)"
        MenuController.shared.fetchImage(url: menuItem.imageURL)
        {
            (image)in
            guard let image = image else {
                return}
            DispatchQueue.main.async {
                self.mealImage.image = image
                self.wallPaper.image = image
                self.blurEffect()
           
            }
        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func orderButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: [], animations: {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    
        MenuController.shared.order.menuItmes.append(menuItem)
    }
    func blurEffect() {

        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: wallPaper.image!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(25, forKey: kCIInputRadiusKey)

        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")

        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        wallPaper.image = processedImage
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
