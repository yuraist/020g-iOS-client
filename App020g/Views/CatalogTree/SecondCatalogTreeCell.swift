//
//  SecondCatalogTreeCell.swift
//  App020g
//
//  Created by Юрий Истомин on 17/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class SecondCatalogTreeCell: UITableViewCell {
  
  var category: CatalogTreeChildCategory? {
    didSet {
      clearCell()
      setupCell()
    }
  }
  
  private let categoryLabel: UILabel = {
    let label = UILabel()
    label.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return label
  }()
  
  private let plusMinusIcon: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate))
    imageView.tintColor = ApplicationColors.darkBlue
    imageView.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return imageView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubviews(categoryLabel, plusMinusIcon)
    setConstraintsForSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func clearCell() {
    switchPlusMinusIcon()
    categoryLabel.text = ""
  }
  
  private func setupCell() {
    if let categoryName = category?.name {
      categoryLabel.text = categoryName
    }
  }
  
  private func setConstraintsForSubviews() {
    addConstraints(withFormat: "H:|-[v0(22)]-[v1]-|", views: plusMinusIcon, categoryLabel)
    plusMinusIcon.heightAnchor.constraint(equalToConstant: 22).isActive = true
    plusMinusIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    categoryLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
  
  private func switchPlusMinusIcon() {
    if category?.isShowingTree ?? false {
      plusMinusIcon.image = getMinusImage()
    } else {
      plusMinusIcon.image = getPlusImage()
    }
  }
  
  private func getPlusImage() -> UIImage {
    return #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate)
  }
  
  private func getMinusImage() -> UIImage {
    return  #imageLiteral(resourceName: "minus").withRenderingMode(.alwaysTemplate)
  }
}
