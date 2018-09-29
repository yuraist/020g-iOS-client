//
//  MenuBarCollectionViewCell.swift
//  020g
//
//  Created by Юрий Истомин on 24/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class MenuBarCollectionViewCell: UICollectionViewCell {
  
  let textLabel: UILabel = {
    let label = UILabel()
    label.text = "Category"
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = ApplicationColors.violet
    addSubview(textLabel)
    
    // Setup textLabel's layout constraints
    textLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    textLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    textLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
