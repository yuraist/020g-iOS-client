//
//  AskViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class AskViewController: UIViewController {
  
  private let inputContainerView = AskView(frame: .zero)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationItem()
    setupNavigationControllerStyle()
    setGrayBackgroundColor()
    addInputContainerView()
    setupConstraintsForInputContainerView()
    addSendButtonAction()
    addHideKeyboardOnTapGestureAction()
    setInputsTextFieldDelegate()
  }
  
  private func setupNavigationControllerStyle() {
    navigationController?.navigationBar.barTintColor = ApplicationColors.darkBlue
    navigationController?.navigationBar.tintColor = ApplicationColors.white
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ApplicationColors.white] as [NSAttributedString.Key: Any]
  }
  
  private func setupNavigationItem() {
    navigationItem.title = "Задать вопрос"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissController))
  }
  
  private func setGrayBackgroundColor() {
    view.backgroundColor = ApplicationColors.gray
  }
  
  private func addInputContainerView() {
    view.addSubview(inputContainerView)
  }
  
  private func setupConstraintsForInputContainerView() {
    inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    inputContainerView.widthAnchor.constraint(equalToConstant: 304).isActive = true
    inputContainerView.heightAnchor.constraint(equalToConstant: 370).isActive = true
  }
  
  private func addSendButtonAction() {
    if formIsValid() {
      sendAskQuestionRequest()
    }
  }
  
  private func formIsValid() -> Bool {
    return true
  }
  
  private func sendAskQuestionRequest() {
    let data = getData()
    ApiHandler.shared.askQuestion(data: data) {
      DispatchQueue.main.async {
        self.clearInputs()
      }
    }
  }
  
  private func getData() -> [String: String] {
    return [String: String]()
  }
  
  private func clearInputs() {
    inputContainerView.emailInput.textField.text = ""
    inputContainerView.nameInput.textField.text = ""
    inputContainerView.phoneInput.textField.text = ""
    inputContainerView.textView.text = ""
  }
  
  private func addHideKeyboardOnTapGestureAction() {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc private func dismissController() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func hideKeyboard() {
    view.endEditing(true)
  }
  
  private func setInputsTextFieldDelegate() {
    inputContainerView.emailInput.textField.delegate = self
    inputContainerView.nameInput.textField.delegate = self
    inputContainerView.phoneInput.textField.delegate = self
  }
}

extension AskViewController: UITextFieldDelegate {

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField.placeholder == "Необязательно, но оперативнее" {
      textField.handlePhoneNumberField(withReplacingString: string, in: range)
      return false
    }
    return textField.textLengthIsValid || string.count < 1
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.placeholder == "Сюда мы отправим ответ на вопрос" {
      if textField.emailFieldIsValid {
        textField.changeAppearanceForValidField()
      } else {
        textField.changeAppearanceForInvalidField()
        return false
      }
    }
    textField.resignFirstResponder()
    return true
  }
}
