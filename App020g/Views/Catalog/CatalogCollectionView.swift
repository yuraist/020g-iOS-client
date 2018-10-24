//
//  CatalogCollectionView.swift
//  020g
//
//  Created by Юрий Истомин on 01/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class CatalogCollectionView: UICollectionView {
  
  private let cellId = "catalogCell"
  private var noMorePages = false
  private var currentPage = 1
  
  var products = [Product]()
  var parentViewController: MainViewController?
  
  var category: Category? {
    didSet {
      products.removeAll()
      currentPage = 1
      fetchProducts()
    }
  }
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    registerCell()
    registerDelegate()
    registerDataSource()
    setGrayBackgroundColor()
    setupTranslatesAutoresizingMaskIntoConstraintsFalse()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func registerCell() {
    register(CatalogCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  private func registerDelegate() {
    delegate = self
  }
  
  private func registerDataSource() {
    dataSource = self
  }
  
  private func setupTranslatesAutoresizingMaskIntoConstraintsFalse() {
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func fetchProducts() {
    guard let category = category else {
      return
    }
    
    if let loadedProducts = parentViewController?.products[category.cat], let lastPage = parentViewController?.lastPages[category.cat] {
      products = loadedProducts
      currentPage = lastPage + 1
    } else {
      currentPage = 1
    }
    
    ApiHandler.shared.fetchProducts(ofCategory: category.cat, page: currentPage) { (success, newProducts) in
      if let newProducts = newProducts {
        if newProducts.count == 0 {
          self.noMorePages = true
        } else {
          self.products.append(contentsOf: newProducts)
          self.parentViewController?.products[category.cat] = self.products
          self.parentViewController?.lastPages[category.cat] = self.currentPage
          
          self.reloadCollectionView()
        }
      }
    }
  }
  
  private func incrementCurrentPage() {
    currentPage += 1
  }
  
  private func reloadCollectionView() {
    DispatchQueue.main.async {
      self.reloadData()
    }
  }
  
}

extension CatalogCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return products.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CatalogCollectionViewCell
    cell.item = products[indexPath.item]
    
    if indexPathIsLast(indexPath) && !noMorePages {
      fetchProducts()
    }
    
    return cell
  }
  
  private func indexPathIsLast(_ indexPath: IndexPath) -> Bool {
    return indexPath.item == (products.count - 1)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: frame.size.width/2 - 1, height: frame.size.width/2 - 2)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = indexPath.item
    let product = products[item]
    let productId = product.id
    ApiHandler.shared.getProduct(withId: productId) { (success, productResponse) in
      if let productResponse = productResponse {
        DispatchQueue.main.async {
          self.showProductTableViewController(productResponse: productResponse)
        }
      }
    }
  }
  
  private func showProductTableViewController(productResponse: ProductResponse) {
    let productTableViewController = ProductTableViewController(response: productResponse)
    parentViewController?.show(productTableViewController, sender: parentViewController)
  }
}
