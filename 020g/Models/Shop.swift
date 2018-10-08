//
//  Shop.swift
//  020g
//
//  Created by Юрий Истомин on 01/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

struct Shop {
  var address: String
  var city: String
  var contacts: String
  var domain: String
  var email: String?
  var phone1: String?
  var phone2: String?
  var phone3: String?
  var vkGroup: String?
  var siteId: Int
  var freePhone: String?
  
  var cellHeight: CGFloat {
    return CGFloat(44 * getNumberOfFields())
  }
  
  init(withDictionary dictionary: [String: Any]) {
    address = dictionary["address"] as! String
    city = dictionary["city"] as! String
    contacts = dictionary["contacts"] as! String
    domain = dictionary["domain"] as! String
    email = dictionary["email"] as? String
    phone1 = dictionary["phone1"] as? String
    phone2 = dictionary["phone2"] as? String
    phone3 = dictionary["phone3"] as? String
    vkGroup = dictionary["vk_group"] as? String
    siteId = Int((dictionary["site_id"] as! NSString).intValue)
    freePhone = dictionary["free_phone"] as? String
  }
  
  func getNumberOfFields() -> Int {
    var numberOfFields = 4
    
    if email != nil {
      numberOfFields += 1
    }
    
    if phone1 != nil {
      numberOfFields += 1
    }
    
    if phone2 != nil {
      numberOfFields += 1
    }
    
    if phone3 != nil {
      numberOfFields += 1
    }
    
    if freePhone != nil {
      numberOfFields += 1
    }
    
    if vkGroup != nil {
      numberOfFields += 1
    }
    
    return numberOfFields
  }
}
