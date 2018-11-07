//
//  SearchCatalogTableViewCell.swift
//  App020g
//
//  Created by Юрий Истомин on 07/11/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class SearchCatalogTableViewCell: UITableViewCell {
  
  var catalogCollectionView = SearchCatalogCollectionView()
  
  init(reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    
    addCatalogCollectionView()
    setConstraintsForCatalogCollectionView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addCatalogCollectionView() {
    addSubview(catalogCollectionView)
  }
  
  private func setConstraintsForCatalogCollectionView() {
    addConstraints(withFormat: "H:|[v0]|", views: catalogCollectionView)
    addConstraints(withFormat: "V:|[v0]|", views: catalogCollectionView)
  }
}
