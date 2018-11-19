//
//  SearchBreadcrumbsCell.swift
//  App020g
//
//  Created by Юрий Истомин on 06/11/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class SearchBreadcrumbsCell: UICollectionViewCell {
  
  let breadcrumbsView = BreadcrumbsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
    addBreadcrumbsCollectionView()
    setupConstraintsForBreadcrumbsView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addBreadcrumbsCollectionView() {
    addSubview(breadcrumbsView)
  }
  
  private func setupConstraintsForBreadcrumbsView() {
    addConstraints(withFormat: "H:|[v0]|", views: breadcrumbsView)
    addConstraints(withFormat: "V:|[v0]|", views: breadcrumbsView)
  }
}
