//
//  AuthorizationViewModel.swift
//  App020g
//
//  Created by Юрий Истомин on 05/11/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import Foundation

class Observable<T> {
  typealias Listener = (T) -> Void
  var listener: Listener?
  
  var value: T {
    didSet {
      listener?(value)
    }
  }
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}

class AuthorizationViewModel {
  
  private let serverManager: ServerManager
  
  var email = Observable("")
  var name = Observable("")
  var password = Observable("")
  var phoneNumber = Observable("")
  
  init(manager: ServerManager) {
    self.serverManager = manager
  }
}

// MARK: - Public methods
extension AuthorizationViewModel {
  
  func update(email: String) {
    self.email.value = email
  }
  
  func update(phoneNumber: String) {
    var newString = phoneNumber
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
    
    self.phoneNumber.value = newString
  }
}

// MARK: - Private methods
extension AuthorizationViewModel {
  
  private func validate(email: String) -> Bool {
    let emailMask = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,32}"
    let regex = try! NSRegularExpression(pattern: emailMask, options: .caseInsensitive)
    return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
  }
  
  
}
