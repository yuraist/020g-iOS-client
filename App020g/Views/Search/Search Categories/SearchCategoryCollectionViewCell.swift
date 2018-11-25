//
//  SearchCategoryCollectionViewCell.swift
//  App020g
//
//  Created by Юрий Истомин on 07/11/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class SearchCategoryCollectionViewCell: UICollectionViewCell {
  
  let label: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return label
  }()
  
  private let bubbleView: UIView = {
    let view = UIView()
    view.backgroundColor = ApplicationColors.greenCategories
    view.layer.cornerRadius = 3
    view.layer.masksToBounds = true
    view.layer.borderColor = ApplicationColors.greenBorder.cgColor
    view.layer.borderWidth = 1
    view.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubviews()
    setConstraintsForSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addSubviews() {
    addSubviews(bubbleView, label)
  }
  
  private func setConstraintsForSubviews() {
    bubbleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    bubbleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    bubbleView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    bubbleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    
    label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
    label.heightAnchor.constraint(equalToConstant: 20).isActive = true
  }
}
