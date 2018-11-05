//
//  TextFieldsDataValidators.swift
//  020g
//
//  Created by Юрий Истомин on 05/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

extension UITextField {
  
  var isValid: Bool {
    get {
      if isEmailField {
        return emailFieldIsValid
      }
      return textLengthIsValid
    }
  }
  
  var isEmailField: Bool {
    return placeholder == "Email"
  }
  
  var isPhoneNumberField: Bool {
    return placeholder == "Телефон (не обязательно)"
  }
  
  var isNameField: Bool {
    return placeholder == "Имя"
  }
  
  var isPasswordField: Bool {
    return placeholder == "Пароль"
  }
  
  var isRepeatPasswordField: Bool {
    return placeholder == "Повторите пароль"
  }
  
  var textLengthIsValid: Bool {
    if let text = text {
      return text.count >= 0 && text.count < 32
    }
    return false
  }
  
  var emailFieldIsValid: Bool {
    return isValidEmailMask
  }
  
  private var isValidEmailMask: Bool {
    if let text = text {
      let emailMask = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,32}"
      let regex = try! NSRegularExpression(pattern: emailMask, options: .caseInsensitive)
      return regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.count)) != nil
    }
    return false
  }
  
  func handlePhoneNumberField(withReplacingString string: String, in range: NSRange) {
    let textFieldString = text! as NSString
    var newString = textFieldString.replacingCharacters(in: range, with: string)
    let validationSet = CharacterSet.decimalDigits.inverted
    
    let numberArray = newString.components(separatedBy: validationSet)
    newString = numberArray.joined()
    
    if newString.count > 11 {
      return
    }
    
    if newString.count > 0 {
      if newString.first == "7" {
        newString.insert("+", at: newString.startIndex)
      } else if newString.first != "8" {
        newString.insert("7", at: newString.startIndex)
        newString.insert("+", at: newString.startIndex)
      } else {
        newString.remove(at: newString.startIndex)
        newString.insert("7", at: newString.startIndex)
        newString.insert("+", at: newString.startIndex)
      }
    }
    
    if newString.count > 2 {
      let newIndex = newString.index(newString.startIndex, offsetBy: 2)
      let newIndexPlus = newString.index(newString.startIndex, offsetBy: 3)
      newString.insert(" ", at: newIndex)
      newString.insert("(", at: newIndexPlus)
    }
    
    if newString.count > 7 {
      let newIndex = newString.index(newString.startIndex, offsetBy: 7)
      let newIndexPlus = newString.index(newString.startIndex, offsetBy: 8)
      newString.insert(")", at: newIndex)
      newString.insert(" ", at: newIndexPlus)
    }
    
    if newString.count > 12 {
      let newIndex = newString.index(newString.startIndex, offsetBy: 12)
      newString.insert("-", at: newIndex)
    }
    
    if newString.count > 15 {
      let newIndex = newString.index(newString.startIndex, offsetBy: 15)
      newString.insert("-", at: newIndex)
    }
    text = newString
  }
  
  func changeAppearanceForValidField() {
    textColor = ApplicationColors.black
  }
  
  func changeAppearanceForInvalidField() {
    textColor = UIColor.red
  }
  
}
