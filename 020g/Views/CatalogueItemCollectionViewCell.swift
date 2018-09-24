//
//  CatalogueItemCollectionViewCell.swift
//  020g
//
//  Created by Юрий Истомин on 24/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class CatalogueItemCollectionViewCell: UICollectionViewCell {
  let numberLabel: UILabel = {
    let label = UILabel()
    label.text = "5"
    label.textColor = ApplicationColor.darkBlue
    label.font = UIFont.systemFont(ofSize: 17, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "Bolle"
    label.textColor = ApplicationColor.darkBlue
    label.font = UIFont.systemFont(ofSize: 17, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let priceLabel: UILabel = {
    let label = UILabel()
    label.text = "5"
    label.isOpaque = false
    label.alpha = 0.7
    label.textColor = ApplicationColor.darkBlue
    label.backgroundColor = ApplicationColor.gray
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 16, weight: .light)
    return label
  }()
}
