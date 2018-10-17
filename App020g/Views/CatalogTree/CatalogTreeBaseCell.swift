//
//  CatalogTreeBaseCell.swift
//  App020g
//
//  Created by Юрий Истомин on 17/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class CatalogTreeBaseCell: UITableViewCell {
  
  var category: CatalogCategory? {
    didSet {
      clearCell()
      setupCell()
    }
  }
  
  private lazy var categoryLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 17, weight: .light)
    label.textColor = ApplicationColors.darkGray
    label.text = ""
    label.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return label
  }()
  
  private lazy var countBage: UILabel = {
    let bage = UILabel()
    bage.backgroundColor = ApplicationColors.midBlue
    bage.textColor = ApplicationColors.white
    bage.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    bage.layer.cornerRadius = 4
    bage.layer.masksToBounds = true
    bage.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return bage
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubviews(categoryLabel, countBage)
    setConstraintsForSubviews()
    
    clearCell()
    setupCell()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraintsForSubviews() {
    addConstraints(withFormat: "H:|-[v0]->=8-[v1]-|", views: categoryLabel, countBage)
    categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    categoryLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    countBage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    countBage.heightAnchor.constraint(equalToConstant: 24).isActive = true
  }
  
  private func clearCell() {
    categoryLabel.text = ""
    countBage.text = ""
  }
  
  private func setupCell() {
    if let category = category {
      categoryLabel.text = category.name
      countBage.text = " \(category.count) "
    }
  }
}
