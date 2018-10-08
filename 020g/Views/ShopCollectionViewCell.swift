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
        clearCell()
        addGeneralSubviews()
        setupConstraintsOfGeneralSubviews()
        
        domainLabel.text = shop.domain
        cityLabel.text = shop.city
        
        if let email = shop.email {
          emailLabel.text = email
          addSubviewAndSetupConstraints(view: emailLabel)
        }
        
        if let phone1 = shop.phone1 {
          phone1Label.text = phone1
          addSubviewAndSetupConstraints(view: phone1Label)
        }
        
        if let phone2 = shop.phone2 {
          phone2Label.text = phone2
          addSubviewAndSetupConstraints(view: phone2Label)
        }
        
        if let phone3 = shop.phone3 {
          phone3Label.text = phone3
          addSubviewAndSetupConstraints(view: phone3Label)
        }
        
        if let freePhone = shop.freePhone {
          freePhoneLabel.text = freePhone + " БЕСПЛАТНО"
          addSubviewAndSetupConstraints(view: freePhoneLabel)
        }
        
        if let vkGroup = shop.vkGroup {
          vkGroupButton.setTitle(vkGroup, for: .normal)
          addSubviewAndSetupConstraints(view: vkGroupButton)
        }
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
    button.contentHorizontalAlignment = .right
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitleColor(ApplicationColors.buttonBlue, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    return button
  }()
  
  private let headerSeparatorView: UIView = {
    let view = UIView()
    view.backgroundColor = ApplicationColors.lightGray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let cityLabel = ShopLabel(text: "City")
  private let emailLabel = ShopLabel(text: "City")
  private let phone1Label = ShopLabel(text: "City")
  private let phone2Label = ShopLabel(text: "City")
  private let phone3Label = ShopLabel(text: "City")
  private let freePhoneLabel = ShopLabel(text: "City")
  
  private var lastBottomYAxisAnchor: NSLayoutYAxisAnchor?
  
  private let vkGroupButton: UIButton = {
    let button = UIButton()
    button.contentHorizontalAlignment = .left
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitleColor(ApplicationColors.buttonBlue, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setGrayBackgroundColor()
    addGeneralSubviews()
    setupConstraintsOfGeneralSubviews()
  }
  
  private func setGrayBackgroundColor() {
    backgroundColor = ApplicationColors.gray
  }
  
  private func addGeneralSubviews() {
    addSubview(headerView)
    headerView.addSubview(domainLabel)
    headerView.addSubview(contactButton)
    addSubview(headerSeparatorView)
    addSubview(cityLabel)
  }
  
  private func setupConstraintsOfGeneralSubviews() {
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
    
    cityLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    cityLabel.topAnchor.constraint(equalTo: headerSeparatorView.bottomAnchor, constant: 12).isActive = true
    cityLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true
    cityLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    lastBottomYAxisAnchor = cityLabel.bottomAnchor
  }
  
  private func addSubviewAndSetupConstraints(view: UIView) {
    if !subviews.contains(view) {
      addSubview(view)
      view.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
      view.topAnchor.constraint(equalTo: lastBottomYAxisAnchor!, constant: 24).isActive = true
      view.widthAnchor.constraint(equalToConstant: 300).isActive = true
      view.heightAnchor.constraint(equalToConstant: 20).isActive = true
      
      lastBottomYAxisAnchor = view.bottomAnchor
    }
  }
  
  private func clearCell() {
    for view in subviews {
      view.removeFromSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
