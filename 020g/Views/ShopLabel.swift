//
//  ShopLabel.swift
//  020g
//
//  Created by Юрий Истомин on 08/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ShopLabel: UILabel {
  init(text: String) {
    super.init(frame: .zero)
    self.text = text
    translatesAutoresizingMaskIntoConstraints = false
    font = UIFont.systemFont(ofSize: 16, weight: .light)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
