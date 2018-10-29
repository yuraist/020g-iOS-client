//
//  FilterOptionCollectionViewCell.swift
//  App020g
//
//  Created by Юрий Истомин on 29/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class FilterOptionCollectionViewCell: UICollectionViewCell {
  
  var option: FilterOption? {
    didSet {
      optionLabel.text = option?.name
    }
  }
  
  override var isSelected: Bool {
    didSet {
      changeBackgroundColor()
      changeTextColor()
    }
  }
  
  private let optionLabel: UILabel = {
    let label = UILabel()
    label.text = "Test 1"
    label.textAlignment = .center
    label.textColor = ApplicationColors.buttonBlue
    label.layer.cornerRadius = 3
    label.layer.masksToBounds = true
    label.layer.borderColor = ApplicationColors.buttonBlue.cgColor
    label.layer.borderWidth = 1
    label.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(optionLabel)
    setOptionLabelConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setOptionLabelConstraints() {
    optionLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    optionLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    optionLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    optionLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
  }
  
  private func changeBackgroundColor() {
    optionLabel.backgroundColor = isSelected ? ApplicationColors.buttonBlue : ApplicationColors.white
  }
  
  private func changeTextColor() {
    optionLabel.textColor = isSelected ? ApplicationColors.white : ApplicationColors.buttonBlue
  }
}
