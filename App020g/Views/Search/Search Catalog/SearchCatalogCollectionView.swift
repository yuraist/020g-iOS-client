//
//  SearchCatalogCollectionView.swift
//  App020g
//
//  Created by Юрий Истомин on 07/11/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class SearchCatalogCollectionView: UICollectionView, UICollectionViewDataSource {
  
  private let cellId = "searchCatalogCell"
  var products = [SearchProduct]() {
    didSet {
      DispatchQueue.main.async {
        self.reloadData()
      }
    }
  }
  
  init() {
    let layout = UICollectionViewFlowLayout()
    super.init(frame: .zero, collectionViewLayout: layout)
    
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
    setGrayBackgroundColor()
    registerCollectionViewCell()
    registerDataSource()
    registerDelegate()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func registerCollectionViewCell() {
    register(SearchCatalogCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  private func registerDelegate() {
    delegate = self
  }
  
  private func registerDataSource() {
    dataSource = self
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return products.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCatalogCollectionViewCell
    cell.product = products[indexPath.item]
    return cell
  }
}

extension SearchCatalogCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
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
