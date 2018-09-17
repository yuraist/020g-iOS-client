//
//  LoginInputContainerView.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class LoginInputContainerView: UIView {

  var isSignUpView = false
  
  let emailTextField = StandardTextField(placeholder: "Email", isSecureTextEntry: false)
  let nameTextField = StandardTextField(placeholder: "Имя", isSecureTextEntry: false)
  let phoneTextField = StandardTextField(placeholder: "Телефон (не обязательно)", isSecureTextEntry: false)
  let passwordTextField = StandardTextField(placeholder: "Пароль", isSecureTextEntry: true)
  let repeatPasswordTextField = StandardTextField(placeholder: "Повторите пароль", isSecureTextEntry: true)
  
  let loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("Войти", for: .normal)
    button.tintColor = ApplicationColor.white
    button.backgroundColor = ApplicationColor.darkBlue
    return button
  }()
  
  init() {
    super.init(frame: .zero)
    addSubview(emailTextField)
    addSubview(nameTextField)
    addSubview(phoneTextField)
    addSubview(passwordTextField)
    addSubview(repeatPasswordTextField)
    addSubview(loginButton)
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
