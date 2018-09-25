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
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 17, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "Bolle"
    label.textColor = ApplicationColor.darkBlue
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 17, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let priceLabel: UILabel = {
    let label = UILabel()
    label.text = "5000 РУБ."
    label.isOpaque = false
    label.alpha = 0.7
    label.textColor = ApplicationColor.white
    label.textAlignment = .center
    label.backgroundColor = ApplicationColor.darkGray
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14, weight: .light)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(numberLabel)
    addSubview(nameLabel)
    addSubview(priceLabel)
    
    // Setup numberLabel's layout constraints
    numberLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    numberLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    numberLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true
    numberLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
    
    // Setup nameLabel's layout constraints
    nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    nameLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
    nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    // Setup priceLabel's layout constraints
    priceLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    priceLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
    priceLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
