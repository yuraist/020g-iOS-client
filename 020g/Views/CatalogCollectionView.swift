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
  
  var category: Category? {
    didSet {
      self.fetchProducts(page: 1)
    }
  }
  
  var products = [Product]() {
    didSet {
      self.reloadCollectionView()
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
  
  private func registerCell() {
    register(CatalogItemCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  private func registerDelegate() {
    delegate = self
  }
  
  private func registerDataSource() {
    dataSource = self
  }
  
  private func setWhiteBackgroundColor() {
    backgroundColor = ApplicationColors.white
  }
  
  private func setGrayBackgroundColor() {
    backgroundColor = ApplicationColors.gray
  }
  
  private func setupTranslatesAutoresizingMaskIntoConstraintsFalse() {
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func fetchProducts(page: Int) {
    guard let category = category else {
      return
    }
    
    ApiHandler.shared.fetchProducts(ofCategory: category.cat, page: page) { (success, products) in
      if let products = products {
        self.products = products
      }
    }
  }
  
  private func reloadCollectionView() {
    DispatchQueue.main.async {
      self.reloadData()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CatalogCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return products.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CatalogItemCollectionViewCell
    cell.item = products[indexPath.item]
    return cell
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
}
