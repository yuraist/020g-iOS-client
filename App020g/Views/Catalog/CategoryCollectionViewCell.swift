//
//  CategoryCollectionViewCell.swift
//  020g
//
//  Created by Юрий Истомин on 01/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
  
  let catalogCollectionView = CatalogCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addCatalogCollectionView()
    setCataloCollectionViewConstraints()
  }

  private func addCatalogCollectionView() {
    addSubview(catalogCollectionView)
  }
  
  private func setCataloCollectionViewConstraints() {
    catalogCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    catalogCollectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    catalogCollectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    catalogCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
