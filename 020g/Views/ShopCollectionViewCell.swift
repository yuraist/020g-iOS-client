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
  
}
