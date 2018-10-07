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
    inputContainerView.sendButton.addTarget(self, action: #selector(sendAskQuestionRequest), for: .touchUpInside)
  }
  
  private func formIsValid() -> Bool {
    return true
  }
  
  @objc private func sendAskQuestionRequest() {
    if formIsValid() {
      let data = getData()
      print(data)
      ApiHandler.shared.askQuestion(data: data) {
        DispatchQueue.main.async {
          self.clearInputs()
          self.showSuccessAlert()
        }
      }
    }
  }
  
  private func getData() -> [String: String] {
    var data = [String: String]()
    
    guard let token = ApiKeys.token else {
      return [String: String]()
    }
    
    data["key"] = token
    
    if inputContainerView.emailInput.textField.emailFieldIsValid {
      data["email"] = inputContainerView.emailInput.textField.text!
    }
    
    if let name = inputContainerView.nameInput.textField.text, name != "" {
      data["name"] = name.components(separatedBy: .whitespaces).joined()
    }
    
    if let phone = inputContainerView.phoneInput.textField.text, phone != "" {
      data["phone"] = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    if let text = inputContainerView.textView.text, text != "" {
      data["text"] = text
    }
    
    return data
  }
  
  private func clearInputs() {
    inputContainerView.emailInput.textField.text = ""
    inputContainerView.nameInput.textField.text = ""
    inputContainerView.phoneInput.textField.text = ""
    inputContainerView.textView.text = ""
  }
  
  private func showSuccessAlert() {
    let alert = UIAlertController(title: "Ваше сообщение отправлено успешно", message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
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
