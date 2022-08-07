//
//  ViewController.swift
//  prodza
//
//  Created by Luka Korica on 8/5/22.
//

import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    var productsManagerNetworkManager = ProductNetworkManager()
    var products: [Product] = []
    var selectedItem = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shop"
        
        // Collection view setup
        self.productsCollectionView.delegate = self
        self.productsCollectionView.dataSource = self
        self.productsCollectionView.register(UINib(nibName: C.productCardViewCell, bundle: nil), forCellWithReuseIdentifier: C.productCardViewCell)
        
        productsManagerNetworkManager.delegate = self
        
        fetchProducts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == C.showProductDetail {
            let vc = segue.destination as! ProductDetailViewController
            vc.product = self.products[selectedItem]
        }
    }
    
    // Manages spinning circle and fetching products
    func fetchProducts() {
        // Spinner
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 128, height: 128)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        
        self.view.addSubview(activityIndicator)
        productsManagerNetworkManager.fetchProducts()
    }
}

// MARK: - UICollectionView - Delegate, Data source
extension ProductListViewController: UICollectionViewDelegate,
                                        UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // Animation for loading in cells
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.productsCollectionView {
            let translationTransorm = CATransform3DTranslate(CATransform3DIdentity, -6, 15, 0)
            cell.layer.transform = translationTransorm
            cell.alpha = 0
            UIView.animate(withDuration: 0.45) {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.productCardViewCell, for: indexPath) as! ProductCardViewCell
        let product = self.products[indexPath.row]
                
        let urlImage = URL(string: product.image_link)!
        cell.productImageView.downloadImage(from: urlImage)
        cell.productImageView.layer.cornerRadius = 20
        
        cell.productNameLabel.text = product.name
        cell.productBrandLabel.text = product.brand
        cell.priceLabel.text = "$ \(product.price)"
        return cell
    }
    
    // Setting the size of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfSets = CGFloat(2)
        if UIDevice.current.orientation.isLandscape {
            numberOfSets = CGFloat(4)
        }
        let width = (collectionView.frame.size.width - (numberOfSets * view.frame.size.width / 15)) / numberOfSets
        let height = CGFloat(320)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath.row
        performSegue(withIdentifier: C.showProductDetail, sender: self)
    }
    
}


// MARK: - ProductNetworkManagerDelegate
extension ProductListViewController: ProductNetworkManagerDelegate {
    func didUpdateProducts(_ productNetworkManager: ProductNetworkManager, products: [Product]) {
        DispatchQueue.main.async {
            self.products = products
            self.activityIndicator.stopAnimating()
            self.productsCollectionView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
        // Retry fetching data again
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { self.productsManagerNetworkManager.fetchProducts() }
        
    }
}
