//
//  AccessoryButton.swift
//  App020g
//
//  Created by Юрий Истомин on 05/11/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class AccessoryButton: UIButton {
  
  init(title: String, contentAlignment alignment: UIControl.ContentHorizontalAlignment) {
    super.init(frame: .zero)
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
    setTitle(title, for: .normal)
    titleLabel?.font = UIFont.systemFont(ofSize: 15)
    contentHorizontalAlignment = alignment
    setTitleColor(ApplicationColors.buttonBlue, for: .normal)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
