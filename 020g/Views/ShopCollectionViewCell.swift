//
//  ShopCollectionViewCell.swift
//  020g
//
//  Created by Юрий Истомин on 02/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {
  
  var cellHeight: CGFloat {
    return CGFloat(44 * countFields)
  }
  
  var shop: Shop? {
    didSet {
      setCountFields()
      addInfoFields()
    }
  }
  
  private var countFields = 4
  
  private func setCountFields() {
    if shop?.email != nil {
      incrementCountFields()
    }
    
    if shop?.phone1 != nil {
      incrementCountFields()
    }
    
    if shop?.phone2 != nil {
      incrementCountFields()
    }
    
    if shop?.phone3 != nil {
      incrementCountFields()
    }
    
    if shop?.freePhone != nil {
      incrementCountFields()
    }
    
    if shop?.vkGroup != nil {
      incrementCountFields()
    }
  }
  
  private func incrementCountFields() {
    countFields += 1
  }
  
  private func addInfoFields() {
    createAndSetupDomainView()
  }
  
  private func createAndSetupDomainView() {
    let domainView = DomainView(withDomain: shop!.domain)
    addSubview(domainView)
    setupDomainViewConstraints(domainView)
    
    let cityField = ShopInfoFieldView(info: shop!.city)
    addSubview(cityField)
    setupConstraints(forView: cityField, withPreviousView: domainView)
  }
  
  private func setupDomainViewConstraints(_ view: DomainView) {
    view.topAnchor.constraint(equalTo: topAnchor).isActive = true
    view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    view.heightAnchor.constraint(equalToConstant: 44).isActive = true
  }
  
  private func setupConstraints(forView view: UIView, withPreviousView prev: UIView) {
    view.topAnchor.constraint(equalTo: prev.bottomAnchor).isActive = true
    view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    view.heightAnchor.constraint(equalToConstant: 44).isActive = true
  }
}
