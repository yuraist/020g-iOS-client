//
//  TextFieldsDataValidators.swift
//  020g
//
//  Created by Юрий Истомин on 05/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

extension UITextField {
  
  var isEmailField: Bool {
    return placeholder == "Email"
  }
  
  var isPhoneNumberField: Bool {
    return placeholder == "Телефон (не обязательно)"
  }
  
  var isValidEmail: Bool {
    return isValidEmailMask
  }
  
  var isValidTextLength: Bool {
    if let text = text {
      return text.count >= 0 && text.count < 32
    }
    return false
  }
  
  private var isValidEmailMask: Bool {
    if let text = text {
      let emailMask = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,32}"
      let regex = try! NSRegularExpression(pattern: emailMask, options: .caseInsensitive)
      return regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.count)) != nil
    }
    return false
  }
  
  func setValid() {
    textColor = ApplicationColors.black
  }
  
  func setInvalid() {
    textColor = UIColor.red
  }
  
}
