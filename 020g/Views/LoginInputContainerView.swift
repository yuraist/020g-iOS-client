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
  
  var inputs: [StandardTextField]
  
  let loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("Войти", for: .normal)
    button.tintColor = ApplicationColor.white
    button.backgroundColor = ApplicationColor.darkBlue
    button.layer.cornerRadius = 5
    button.layer.masksToBounds = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override init(frame: CGRect) {
    self.inputs = [emailTextField, nameTextField, phoneTextField, passwordTextField, repeatPasswordTextField]
    super.init(frame: frame)
    
    setupContainerView()
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupContainerView() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = ApplicationColor.white
    layer.cornerRadius = 5
    layer.shadowColor = UIColor(white: 0, alpha: 1).cgColor
    layer.shadowOpacity = 0.16
    layer.shadowRadius = 6
    layer.shadowOffset = CGSize(width: 0, height: 0)
  }
  
  private func setupSubviews() {
    addSubview(emailTextField)
    addSubview(nameTextField)
    addSubview(phoneTextField)
    addSubview(passwordTextField)
    addSubview(repeatPasswordTextField)
    addSubview(loginButton)
    
    if isSignUpView {
      nameTextField.isHidden = false
      phoneTextField.isHidden = false
      repeatPasswordTextField.isHidden = false
      loginButton.setTitle("Регистрация", for: .normal)
    } else {
      nameTextField.isHidden = true
      phoneTextField.isHidden = true
      repeatPasswordTextField.isHidden = true
      loginButton.setTitle("Войти", for: .normal)
    }
    
    emailTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    emailTextField.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
    emailTextField.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
    emailTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    var previousItem = emailTextField
    for item in inputs {
      if !item.isHidden && item != emailTextField {
        item.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        item.topAnchor.constraint(equalTo: previousItem.bottomAnchor, constant: 16).isActive = true
        item.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
        item.heightAnchor.constraint(equalToConstant: 44).isActive = true
        previousItem = item
      }
    }
    
    loginButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    loginButton.topAnchor.constraint(equalTo: previousItem.bottomAnchor, constant: 16).isActive = true
    loginButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    loginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
  }
  
}
