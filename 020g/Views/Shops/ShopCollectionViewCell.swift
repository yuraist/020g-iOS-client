//
//  ShopCollectionViewCell.swift
//  020g
//
//  Created by Юрий Истомин on 02/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ContactButton: UIButton {
  
  var contactUrl: URL?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setTitle("КОНТАКТЫ", for: .normal)
    contentHorizontalAlignment = .right
    translatesAutoresizingMaskIntoConstraints = false
    setTitleColor(ApplicationColors.buttonBlue, for: .normal)
    titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class ShopCollectionViewCell: UICollectionViewCell {
  
  var shop: Shop? {
    didSet {
      if let shop = shop {
        clearCell()
        addGeneralSubviews()
        setupConstraintsOfGeneralSubviews()
        
        domainLabel.text = shop.domain
        cityLabel.text = shop.city
        if let url = URL(string: "https://www.google.com/s2/favicons?domain=\(shop.domain)") {
          shopImageView.kf.setImage(with: url)
        }
        contactButton.contactUrl = URL(string: shop.contacts)
        
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
          freePhoneLabel.text = freePhone
          addSubviewAndSetupConstraints(view: freePhoneLabel)
        }
        
        if let vkGroup = shop.vkGroup {
          vkGroupButton.contentHorizontalAlignment = .left
          vkGroupButton.contactUrl = URL(string: vkGroup)
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
  
  private let shopImageView: UIImageView = {
    let iv = UIImageView()
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  private let domainLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let contactButton = ContactButton(frame: .zero)
  
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
  private let freePhoneLabel: ShopLabel = {
    let label = ShopLabel(text: "City")
    
    let freeLabel = ShopLabel(text: "БЕCПЛАТНО!")
    label.addSubview(freeLabel)
    freeLabel.rightAnchor.constraint(equalTo: label.rightAnchor).isActive = true
    freeLabel.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
    freeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    freeLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    
    return label
  }()
  
  private var lastBottomYAxisAnchor: NSLayoutYAxisAnchor?
  
  let vkGroupButton = ContactButton(frame: .zero)
  
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
    headerView.addSubview(shopImageView)
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
    
    shopImageView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).isActive = true
    shopImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
    shopImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
    shopImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
    
    domainLabel.leftAnchor.constraint(equalTo: shopImageView.rightAnchor, constant: 16).isActive = true
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
      view.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
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
