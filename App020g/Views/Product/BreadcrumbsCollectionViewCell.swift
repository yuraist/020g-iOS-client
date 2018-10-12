//
//  BreadcrumbsCollectionViewCell.swift
//  020g
//
//  Created by Юрий Истомин on 11/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class BreadcrumbCollectionViewCell: UICollectionViewCell {
  
  var breadcrumb: Breadcrumb? {
    didSet {
      if let breadcrumb = breadcrumb {
        breadcrumbNameLabel.text = breadcrumb.name
        if !isLastCell {
          breadcrumbNameLabel.text = breadcrumb.name + "  >"
        } else {
          breadcrumbNameLabel.textAlignment = .left
        }
      }
    }
  }
  
  var isLastCell = false
  
  private let breadcrumbNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = ApplicationColors.lightGray
    label.font = UIFont.systemFont(ofSize: 14)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    addLabel()
    setupLabelConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addLabel() {
    addSubview(breadcrumbNameLabel)
  }
  
  private func setupLabelConstraints() {
    breadcrumbNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    breadcrumbNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    breadcrumbNameLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -4).isActive = true
    breadcrumbNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
  }
}
