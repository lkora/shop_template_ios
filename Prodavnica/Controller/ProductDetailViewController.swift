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
        
        setUI()
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
        plusButton.layer.cornerRadius = plusButton.frame.size.width / 3
        minusButton.layer.cornerRadius = minusButton.frame.size.width / 3
        bottomView.layer.cornerRadius = 15
        
        // Add description
        self.DescriptionLabel.text = product!.description

        // Bottom bar
        let translationTransorm = CATransform3DTranslate(CATransform3DIdentity, 0, 60, 0)
        self.bottomView.layer.transform = translationTransorm
        UIView.animate(withDuration: 0.3) {
            self.bottomView.layer.transform = CATransform3DIdentity
        }
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
    
    // TODO: Move to custom views
    func setUI(){
        // Bottom bar elements
        
        // Blurring of bottom bar
        self.bottomView.backgroundColor = self.bottomView.backgroundColor!.withAlphaComponent(0.3)
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 15
        blurView.clipsToBounds = true
        self.bottomView.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: self.bottomView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor),
            blurView.heightAnchor.constraint(equalTo: self.bottomView.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: self.bottomView.widthAnchor)
        ])
        
        // Bottom buttons
        self.buyButton.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        self.buyButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.buyButton.layer.shadowRadius = 6.0
        self.buyButton.layer.shadowOpacity = 0.1
        self.buyButton.layer.cornerRadius = 15.0
        self.buyButton.layer.masksToBounds = false
        self.buyButton.layer.shadowPath = UIBezierPath(roundedRect: self.buyButton.bounds, cornerRadius: self.buyButton.layer.cornerRadius).cgPath
        
        self.addToCartButton.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        self.addToCartButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.addToCartButton.layer.shadowRadius = 6.0
        self.addToCartButton.layer.shadowOpacity = 0.1
        self.addToCartButton.layer.cornerRadius = 15.0
        self.addToCartButton.layer.masksToBounds = false
        self.addToCartButton.layer.shadowPath = UIBezierPath(roundedRect: self.buyButton.bounds, cornerRadius: self.buyButton.layer.cornerRadius).cgPath
    }
}

