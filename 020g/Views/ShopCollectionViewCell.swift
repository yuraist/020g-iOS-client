//
//  ShopCollectionViewCell.swift
//  020g
//
//  Created by Юрий Истомин on 02/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {
  
  var shop: Shop? {
    didSet {
      if let shop = shop {
        domainLabel.text = shop.domain
      }
    }
  }
  
  private let headerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let domainLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let contactButton: UIButton = {
    let button = UIButton()
    button.setTitle("КОНТАКТЫ", for: .normal)
    button.setTitleColor(ApplicationColors.buttonBlue, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    button.titleLabel?.textAlignment = .right
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let headerSeparatorView: UIView = {
    let view = UIView()
    view.backgroundColor = ApplicationColors.lightGray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setGrayBackgroundColor()
    addSubviews()
    setupConstraintsOfSubviews()
  }
  
  private func setGrayBackgroundColor() {
    backgroundColor = ApplicationColors.gray
  }
  
  private func addSubviews() {
    addSubview(headerView)
    headerView.addSubview(domainLabel)
    headerView.addSubview(contactButton)
    addSubview(headerSeparatorView)
  }
  
  private func setupConstraintsOfSubviews() {
    headerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    headerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    headerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    domainLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).isActive = true
    domainLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
    domainLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true
    domainLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    contactButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -16).isActive = true
    contactButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
    contactButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    contactButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    headerSeparatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    headerSeparatorView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
    headerSeparatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    headerSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
