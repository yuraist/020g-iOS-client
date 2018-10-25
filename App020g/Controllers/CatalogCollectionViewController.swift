//
//  CatalogCollectionViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CatalogCollectionViewController: UICollectionViewController {
  
  var category: CatalogTreeChildCategory?
  var filter: FilterRequest?
  var products = [CodableProduct]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.setWhiteBackgroundColor()
    setNavigationBarTitle()
    registerCollectionViewCell()
    fetchProducts()
  }
  
  private func setNavigationBarTitle() {
    navigationItem.title = category?.name ?? ""
  }
  
  private func registerCollectionViewCell() {
    collectionView.register(CatalogCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  private func fetchProducts() {
    guard let category = category else {
      return
    }
    
    if filter == nil {
      filter = FilterRequest(category: "\(category.id)", page: "1", cost: nil, options: nil, sort: nil)
    }
    
    ApiHandler.shared.fetchFilteredProducts(withFilter: filter!) { (response) in
      if let catalogResponse = response {
        self.products.append(contentsOf: catalogResponse.list)
        self.reloadCollectionView()
      }
    }
  }
  
  private func reloadCollectionView() {
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return products.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CatalogCollectionViewCell
    cell.codableProduct = products[indexPath.item]
    return cell
  }
}

extension CatalogCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width/2 - 1, height: collectionView.frame.size.width/2 - 2)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
}
