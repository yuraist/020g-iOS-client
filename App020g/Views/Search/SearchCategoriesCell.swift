//
//  SearchCategoriesCell.swift
//  App020g
//
//  Created by Юрий Истомин on 07/11/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class SearchCategoriesCell: UITableViewCell {
  
  let categoriesCollectionView = SearchCategoriesCollectionView()
  
  init(reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    
    addCollectionView()
    setConstraintsForCollectionView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addCollectionView() {
    addSubview(categoriesCollectionView)
  }
  
  private func setConstraintsForCollectionView() {
    addConstraints(withFormat: "H:|[v0]|", views: categoriesCollectionView)
    addConstraints(withFormat: "V:|[v0]|", views: categoriesCollectionView)
  }
  
}
