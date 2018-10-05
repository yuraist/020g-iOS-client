//
//  AuthorizationViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController {
  
  private let loginInputContainerView = LoginInputContainerView(frame: .zero)
  private var loginInputContainerViewHeightAnchor: NSLayoutConstraint?
  
  private let switchModeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Зарегистрироваться", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    button.contentHorizontalAlignment = .left
    button.setTitleColor(ApplicationColors.buttonBlue, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let recallPasswordButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Напомнить пароль", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    button.contentHorizontalAlignment = .right
    button.setTitleColor(ApplicationColors.buttonGray, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setGrayBackgroundColorToView()
    setupNavigationControllerAppearance()
    setupNavigationItem()
    setControllerAsTextFieldsDelegate()
    addSubviews()
    setupConstraintsToSubviews()
    setupButtonTargets()
  }
  
  private func setGrayBackgroundColorToView() {
    view.backgroundColor = ApplicationColors.gray
  }
  
  private func setupNavigationControllerAppearance() {
    navigationController?.navigationBar.barTintColor = ApplicationColors.darkBlue
    navigationController?.navigationBar.tintColor = ApplicationColors.white
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ApplicationColors.white] as [NSAttributedString.Key: Any]
  }
  
  private func setupNavigationItem() {
    navigationItem.title = "Вход"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissController))
  }
  
  private func setControllerAsTextFieldsDelegate() {
    loginInputContainerView.emailTextField.delegate = self
    loginInputContainerView.passwordTextField.delegate = self
    loginInputContainerView.nameTextField.delegate = self
    loginInputContainerView.repeatPasswordTextField.delegate = self
    loginInputContainerView.phoneTextField.delegate = self
  }
  
  private func addSubviews() {
    view.addSubview(loginInputContainerView)
    view.addSubview(switchModeButton)
    view.addSubview(recallPasswordButton)
  }
  
  private func setupConstraintsToSubviews() {
    loginInputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    loginInputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    loginInputContainerView.widthAnchor.constraint(equalToConstant: 304).isActive = true
    loginInputContainerViewHeightAnchor = loginInputContainerView.heightAnchor.constraint(equalToConstant: LoginInputContainerView.loginHeight)
    loginInputContainerViewHeightAnchor?.isActive = true
    
    switchModeButton.leftAnchor.constraint(equalTo: loginInputContainerView.leftAnchor).isActive = true
    switchModeButton.topAnchor.constraint(equalTo: loginInputContainerView.bottomAnchor, constant: 16).isActive = true
    switchModeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    switchModeButton.widthAnchor.constraint(equalTo: loginInputContainerView.widthAnchor, multiplier: 0.5).isActive = true
    
    recallPasswordButton.rightAnchor.constraint(equalTo: loginInputContainerView.rightAnchor).isActive = true
    recallPasswordButton.topAnchor.constraint(equalTo: loginInputContainerView.bottomAnchor, constant: 16).isActive = true
    recallPasswordButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    recallPasswordButton.widthAnchor.constraint(equalTo: loginInputContainerView.widthAnchor, multiplier: 0.5).isActive = true
  }
  
  private func setupButtonTargets() {
    loginInputContainerView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    switchModeButton.addTarget(self, action: #selector(changeFormMode), for: .touchUpInside)
    recallPasswordButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
  }
  
  @objc private func login() {
    validateForm()
  }
  
  @objc private func changeFormMode() {
    loginInputContainerView.changeContainerViewMode()
    
    changeNavigationItemTitle()
    changeSwitchingModeButtonTitle()
    changeLayoutsOfContainerView()
  }
  
  @objc private func forgotPassword() {
    show(ForgotPasswordViewController(), sender: self)
  }
  
  @objc private func dismissController() {
    dismiss(animated: true, completion: nil)
  }
  
  private func changeNavigationItemTitle() {
    navigationItem.title = loginInputContainerView.isSignUpView ? "Регистрация" : "Вход"
  }
 
  private func changeSwitchingModeButtonTitle() {
    switchModeButton.setTitle(loginInputContainerView.isSignUpView ? "Войти" : "Зарегистрироваться", for: .normal)
  }
  
  private func changeLayoutsOfContainerView() {
    loginInputContainerViewHeightAnchor?.isActive = false
    loginInputContainerViewHeightAnchor = loginInputContainerView.heightAnchor.constraint(equalToConstant: loginInputContainerView.isSignUpView ? LoginInputContainerView.signUpHeight : LoginInputContainerView.loginHeight)
    loginInputContainerViewHeightAnchor?.isActive = true
  }
  
  private func validateForm() {
    
  }
}

extension AuthorizationViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if textField.isPhoneNumberField {
      let textFieldString = textField.text! as NSString
      var newString = textFieldString.replacingCharacters(in: range, with: string)
      let validationSet = CharacterSet.decimalDigits.inverted
      
      let numberArray = newString.components(separatedBy: validationSet)
      newString = numberArray.joined()
      
      
      if newString.count > 11 {
        return false
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
      
      textField.text = newString
      return false
    }
    
    return textField.isValidTextLength || string.count < 1
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.isEmailField {
      if textField.isValidEmail {
        textField.setValid()
        textField.resignFirstResponder()
        return true
      } else {
        textField.setInvalid()
        return false
      }
    }
    
    textField.resignFirstResponder()
    return false
  }
}
