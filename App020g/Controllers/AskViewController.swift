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
    addKeyboardNotification()
    setupNavigationItem()
    setupNavigationControllerStyle()
    setGrayBackgroundColor()
    addInputContainerView()
    setupConstraintsForInputContainerView()
    addSendButtonAction()
    addHideKeyboardOnTapGestureAction()
    setInputsTextFieldDelegate()
    fillInputsIfUserIsLoggedIn()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: view.window)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: view.window)
  }
  
  private func addKeyboardNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private var oldYPosition: CGFloat = 0
  
  @objc private func keyboardWillShow(sender: Notification) {
    oldYPosition = inputContainerView.frame.origin.y
    if inputContainerView.textView.isFirstResponder {
      if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        let newYPosition = view.frame.size.height - (keyboardSize.height + 70 + inputContainerView.frame.size.height)
        UIView.animate(withDuration: 0.3) {
          self.inputContainerView.frame.origin.y = newYPosition
        }
      }
    }
  }
  
  @objc private func keyboardWillHide(sender: Notification) {
    if oldYPosition != inputContainerView.frame.origin.y {
      UIView.animate(withDuration: 0.3) {
        self.inputContainerView.frame.origin.y = self.oldYPosition
      }
    }
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
      ServerManager.shared.askQuestion(data: data) {
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
    inputContainerView.textView.delegate = self
  }
  
  private func fillInputsIfUserIsLoggedIn() {
    ServerManager.shared.getUserInfo { (success, user) in
      if let user = user {
        DispatchQueue.main.async {
          self.fillInputs(withUser: user)
        }
      }
    }
  }
  
  private func fillInputs(withUser user: User) {
    inputContainerView.nameInput.textField.text = user.name
    inputContainerView.emailInput.textField.text = user.email
    
    if let phone = user.phone {
      inputContainerView.phoneInput.textField.handlePhoneNumberField(withReplacingString: phone, in: NSRange(location: 0, length: 0))
    }
  }
}

extension AskViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField.placeholder == "Необязательно, но оперативнее" {
      textField.handlePhoneNumberField(withReplacingString: string, in: range)
      return false
    }
    
    if string == " " {
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

extension AskViewController: UITextViewDelegate {
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
    if text == "\n" {
      textView.resignFirstResponder()
      return false
    }
    
    let textViewString = textView.text as NSString
    let newString = textViewString.replacingCharacters(in: range, with: text)
    
    if newString.count <= 300 {
      textView.text = newString
    }
    
    inputContainerView.textViewLetterCountLabel.text = "\(300 - textView.text.count)"
    return false
  }
  
}

