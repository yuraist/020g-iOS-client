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

enum FormValidationState {
  case valid
  case invalid(String)
}

enum FormType {
  case signIn
  case signUp
}

class AuthorizationViewModel {
  
  private let serverManager: ServerManager
  
  var email = Observable("")
  var name = Observable("")
  var password = Observable("")
  var repeatPassword = Observable("")
  var phoneNumber = Observable("")
  
  var signInData: [String: String] {
    return ["login": email.value, "password": password.value, "key": ApiKeys.token!]
  }
  
  var signUpData: [String: String] {
    return ["email": email.value,
            "name": name.value,
            "phone": phoneNumber.value,
            "password": password.value,
            "key": ApiKeys.token!]
  }
  
  init(manager: ServerManager) {
    self.serverManager = manager
  }
}

// MARK: - Public methods
extension AuthorizationViewModel {
  
  func update(email: String) {
    if stringHasValidLength(email) {
      self.email.value = handled(email: email)
    }
  }
  
  func update(name: String) {
    if stringHasValidLength(name) {
      self.name.value = handled(name: name)
    }
  }
  
  func update(password: String) {
    self.password.value = password
  }
  
  func update(repeatedPassword: String) {
    self.repeatPassword.value = repeatedPassword
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
  
  func validate(formOfType type: FormType) -> FormValidationState {
    switch type {
    case .signIn:
      if !validate(email: email.value) {
        return .invalid("Введен недействительный Email")
      }
      if password.value == "" {
        return .invalid("Введите пароль")
      }
      return .valid
    case .signUp:
      if !validate(email: email.value) {
        return .invalid("Введен недействительный Email")
      }
      if name.value == "" {
        return .invalid("Введите имя")
      }
      if password.value == "" {
        return .invalid("Введите пароль")
      }
      if repeatPassword.value == "" {
        return .invalid("Введите пароль повторно")
      }
      if password.value != repeatPassword.value {
        return .invalid("Пароли не совпадают")
      }
      return .valid
    }
  }
}

// MARK: - Private methods
extension AuthorizationViewModel {
  
  private func validate(email: String) -> Bool {
    let emailMask = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,32}"
    let regex = try! NSRegularExpression(pattern: emailMask, options: .caseInsensitive)
    return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
  }
  
  private func stringHasValidLength(_ str: String) -> Bool {
    return str.count >= 0 && str.count < 32
  }
  
  private func handled(email: String) -> String {
    return email.components(separatedBy: " ").joined()
  }
  
  private func handled(name: String) -> String {
    return name.components(separatedBy: " ").joined()
  }
}
