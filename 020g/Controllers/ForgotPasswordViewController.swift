//
//  ForgotPasswordViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
  
  private let inputContainerView = RecallPasswordView(frame: .zero)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationItemTitle()
    setGrayBackgroundColor()
    addHideKeyboardActionWhenTappedOutsideInputContainer()
    addInputContainerView()
    setupConstraintsOfInputContainerView()
    setupInputContainerViewTextFieldDelegate()
  }
  
  private func setNavigationItemTitle() {
    navigationItem.title = "Напомнить пароль"
  }
  
  private func setGrayBackgroundColor() {
    view.backgroundColor = ApplicationColors.gray
  }
  
  private func addHideKeyboardActionWhenTappedOutsideInputContainer() {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc private func hideKeyboard() {
    view.endEditing(true)
  }
  
  private func addInputContainerView() {
    view.addSubview(inputContainerView)
  }
  
  private func setupConstraintsOfInputContainerView() {
    inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    inputContainerView.widthAnchor.constraint(equalToConstant: 304).isActive = true
    inputContainerView.heightAnchor.constraint(equalToConstant: 168).isActive = true
  }
  
  private func setupInputContainerViewTextFieldDelegate() {
    inputContainerView.emailTextField.delegate = self
  }
  
}

extension ForgotPasswordViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.isValid {
      textField.changeAppearanceForValidField()
      textField.resignFirstResponder()
    } else {
      textField.changeAppearanceForInvalidField()
    }
    return textField.isValid
  }
}
