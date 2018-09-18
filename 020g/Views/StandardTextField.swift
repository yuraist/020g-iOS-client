//
//  StandardTextField.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class StandardTextField: UITextField {
  
  var textFieldHeightAnchor: NSLayoutConstraint?
  
  init(placeholder: String, isSecureTextEntry: Bool) {
    super.init(frame: .zero)
    
    self.placeholder = placeholder
    self.layer.cornerRadius = 5
    self.layer.masksToBounds = true
    self.borderStyle = .roundedRect
    self.isSecureTextEntry = isSecureTextEntry
    self.translatesAutoresizingMaskIntoConstraints = false
    self.font = UIFont.systemFont(ofSize: 15)
    
    if placeholder == "Email" {
      self.keyboardType = .emailAddress
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
