//
//  LoginInputContainerView.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class LoginInputContainerView: UIView {
  
  static let signUpHeight: CGFloat = 260
  static let loginHeight: CGFloat = 140
  
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
    button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
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
    addSubviews()
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
  
  private func addSubviews() {
    addSubview(emailTextField)
    addSubview(nameTextField)
    addSubview(phoneTextField)
    addSubview(passwordTextField)
    addSubview(repeatPasswordTextField)
    addSubview(loginButton)
  }
  
}
