//
//  ProductDetailViewController.swift
//  prodza
//
//  Created by Luka Korica on 8/6/22.
//

import UIKit

class ProductDetailViewController: UIViewController {
    // Outlets
    @IBOutlet weak var productImageView: ProductImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var DescriptionLabel: UILabel!

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!

    // Constraints
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    
    var product: Product?
    var amount: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }
    
    func setupData() {
        self.productImageView.downloadImage(from: URL(string: product!.image_link)!)
        titleLabel.text = product!.name
        brandLabel.text = product!.brand
        priceLabel.text = "$ \(product!.price)"
        
        // Create category
        categoryLabel.text = ""
        if let category = product!.category {
            if category != product!.product_type {
                categoryLabel.text = category
            }
        }
        categoryLabel.text! += " \(product!.product_type)"
        
        // Plus - minus buttons + View
        imageViewHeightConstraint.constant = view.frame.height / 3.5
        plusButton.layer.cornerRadius = plusButton.frame.size.width / 2
        minusButton.layer.cornerRadius = minusButton.frame.size.width / 2
        bottomView.layer.cornerRadius = 15
        
        // Add description
        self.DescriptionLabel.text = product!.description

    }

    // Add or remove Items
    @IBAction func minusButtonPressed(_ sender: Any) {
        amount -= 1
        if amount < 1 {
            amount = 1
        }
        self.amountLabel.text = amount.description
        self.priceLabel.text = "$ \(round(Float(product!.price)! * Float(amount) * 100) / 100)"
    }
    @IBAction func plusButtonPressed(_ sender: Any) {
        amount += 1
        if amount > 100 {
            amount = 100
        }
        self.amountLabel.text = amount.description
        self.priceLabel.text = "$ \(round(Float(product!.price)! * Float(amount) * 100) / 100)"
    }
}

