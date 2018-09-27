//
//  Category.swift
//  020g
//
//  Created by Юрий Истомин on 26/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

/// Structure represents product categories
struct Category: Codable {
  let cat: Int
  let title: String
  
  enum CodingKeys: String, CodingKey {
    case cat
    case title
  }
}

/// Structure represents a list of product categories
struct Categories: Codable {
  let list: [Category]
}
