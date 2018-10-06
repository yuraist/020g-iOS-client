//
//  LoginInputContainerView.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class LoginInputContainerView: UIView {
  
  // Constants for changing view's height
  static let signUpHeight: CGFloat = 236
  static let loginHeight: CGFloat = 140
  
  // In which mode the view is presenting
  var isSignUpView = false {
    didSet {
      changeFormMode()
    }
  }
  
  // Text fields and button for singing up and loggin in
  let emailTextField = StandardTextField(placeholder: "Email", isSecureTextEntry: false)
  let emailSeparatorView = SeparatorView()
  let nameTextField = StandardTextField(placeholder: "Имя", isSecureTextEntry: false)
  let nameSeparatorView = SeparatorView()
  let phoneTextField = StandardTextField(placeholder: "Телефон (не обязательно)", isSecureTextEntry: false)
  let phoneSeparatorView = SeparatorView()
  let passwordTextField = StandardTextField(placeholder: "Пароль", isSecureTextEntry: true)
  let passwordSeparatorView = SeparatorView()
  let repeatPasswordTextField = StandardTextField(placeholder: "Повторите пароль", isSecureTextEntry: true)
  let repeatPasswordSeparatorView = SeparatorView()
  
  let loginButton: StandardButton = {
    let button = StandardButton(frame: .zero)
    button.title = "Войти"
    return button
  }()
  
  // References to the height anchors of the fields that not showing in the login mode
  var nameTextFieldHeightAnchor: NSLayoutConstraint?
  var phoneTextFieldHeightAnchor: NSLayoutConstraint?
  var repeatPasswordTextFieldHeightAnchor: NSLayoutConstraint?
  
  // Array of fields for changing the firstResponder when user's printing
  var inputs: [StandardTextField]
  
  override init(frame: CGRect) {
    self.inputs = [emailTextField, nameTextField, phoneTextField, passwordTextField, repeatPasswordTextField]
    super.init(frame: frame)
    
    setupContainerView()
    addAndSetupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // Setup the view's properties
  private func setupContainerView() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = ApplicationColors.white
    layer.cornerRadius = 5
    layer.shadowColor = UIColor(white: 0, alpha: 1).cgColor
    layer.shadowOpacity = 0.16
    layer.shadowRadius = 6
    layer.shadowOffset = CGSize(width: 0, height: 0)
  }
  
  // Setup subviews and their layout constraints
  private func addAndSetupSubviews() {
    addSubview(emailTextField)
    addSubview(emailSeparatorView)
    addSubview(nameTextField)
    addSubview(nameSeparatorView)
    addSubview(phoneTextField)
    addSubview(phoneSeparatorView)
    addSubview(passwordTextField)
    addSubview(passwordSeparatorView)
    addSubview(repeatPasswordTextField)
    addSubview(repeatPasswordSeparatorView)
    addSubview(loginButton)
    
    // Setup emailTextField layout constraints
    emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    emailTextField.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
    emailTextField.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
    emailTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
    
    // Setup emailSeparatorView layout constraints
    emailSeparatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: -1).isActive = true
    emailSeparatorView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
    emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    // Setup nameTextField layout constraints
    nameTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    nameTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor, constant: 0).isActive = true
    nameTextField.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
    nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: 0)
    nameTextFieldHeightAnchor?.isActive = true
    
    // Setup nameSeparatorView layout constraints
    nameSeparatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: -1).isActive = true
    nameSeparatorView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
    nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    // Setup phoneTextField layout constraints
    phoneTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    phoneTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
    phoneTextField.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
    phoneTextFieldHeightAnchor = phoneTextField.heightAnchor.constraint(equalToConstant: 0)
    phoneTextFieldHeightAnchor?.isActive = true
    
    // Setup phoneSeparatorView layout constraints
    phoneSeparatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    phoneSeparatorView.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: -1).isActive = true
    phoneSeparatorView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
    phoneSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    // Setup passwordTextField layour constraints
    passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    passwordTextField.topAnchor.constraint(equalTo: phoneSeparatorView.bottomAnchor).isActive = true
    passwordTextField.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
    passwordTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
    
    // Setup passwordSeparatorView layout constraints
    passwordSeparatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    passwordSeparatorView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: -1).isActive = true
    passwordSeparatorView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
    passwordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    // Setup repeatPasswordTextField layout constraints
    repeatPasswordTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    repeatPasswordTextField.topAnchor.constraint(equalTo: passwordSeparatorView.bottomAnchor, constant: 0).isActive = true
    repeatPasswordTextField.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
    repeatPasswordTextFieldHeightAnchor = repeatPasswordTextField.heightAnchor.constraint(equalToConstant: 0)
    repeatPasswordTextFieldHeightAnchor?.isActive = true
    
    // Setup repeatPasswordSeparatorView layout constraints
    repeatPasswordSeparatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    repeatPasswordSeparatorView.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: -1).isActive = true
    repeatPasswordSeparatorView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
    repeatPasswordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    // Setup loginButton layout constraints
    loginButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    loginButton.topAnchor.constraint(equalTo: repeatPasswordSeparatorView.bottomAnchor, constant: 16).isActive = true
    loginButton.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
    loginButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
  }
  
  // Switch sign up / login modes
  private func changeFormMode() {
    loginButton.title = isSignUpView ? "Зарегистрироваться" : "Войти"
    
    // Deactivate anchors to change them
    nameTextFieldHeightAnchor?.isActive = false
    phoneTextFieldHeightAnchor?.isActive = false
    repeatPasswordTextFieldHeightAnchor?.isActive = false
    
    nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: isSignUpView ? 32 : 0)
    phoneTextFieldHeightAnchor = phoneTextField.heightAnchor.constraint(equalToConstant: isSignUpView ? 32 : 0)
    repeatPasswordTextFieldHeightAnchor = repeatPasswordTextField.heightAnchor.constraint(equalToConstant: isSignUpView ? 32 : 0)
    
    // Activate changed anchors
    nameTextFieldHeightAnchor?.isActive = true
    phoneTextFieldHeightAnchor?.isActive = true
    repeatPasswordTextFieldHeightAnchor?.isActive = true
  }
  
  func changeContainerViewMode() {
    isSignUpView = !isSignUpView
  }
  
  func getEmailTextFieldData() -> String {
    return emailTextField.text!
  }
  
  func getNameTextFieldHandledData() -> String {
    return nameTextField.text!.components(separatedBy: CharacterSet.whitespaces).joined()
  }
  
  func getPhoneNumberTextFieldHandledData() -> String {
    return phoneTextField.text!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
  }
  
  func getPasswordTextFieldData() -> String {
    return passwordTextField.text!
  }
}
