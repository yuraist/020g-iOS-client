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
  
  private let switchModeButton = AccessoryButton(title: "Зарегистрироваться", contentAlignment: .left)
  private let recallPasswordButton = AccessoryButton(title: "Напомнить пароль", contentAlignment: .right)
  
  private var viewModel: AuthorizationViewModel
  
  init(viewModel: AuthorizationViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.setGrayBackgroundColor()
    setupNavigationControllerAppearance()
    setupNavigationItem()
    
    addSubviews()
    setupConstraintsToSubviews()
    
    setControllerAsTextFieldsDelegate()
    
    setupButtonTargets()
    addHideKeyboardActionWhenTappedOutsideInputContainer()
    
    viewModel.phoneNumber.bind { [unowned self] in
      self.loginInputContainerView.phoneTextField.text = $0
    }
  }
  
  private func setupNavigationControllerAppearance() {
    navigationController?.navigationBar.barTintColor = ApplicationColors.darkBlue
    navigationController?.navigationBar.tintColor = ApplicationColors.white
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ApplicationColors.white] as [NSAttributedString.Key: Any]
  }
  
  private func setupNavigationItem() {
    navigationItem.title = "Вход"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Отмена", style: .done, target: self, action: #selector(dismissController))
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
  
  private func addHideKeyboardActionWhenTappedOutsideInputContainer() {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardAction))
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc
  private func login() {
    if formIsValid() {
      hideKeyboard()
      prepareDataAndSendLoginRequest()
    } else {
      showAlertMessage()
    }
  }
  
  private func prepareDataAndSendLoginRequest() {
    var data = [String: String]()
    
    if submitFormButtonIsLogin() {
      data = getValidLoginData()
    } else {
      data = getValidSignUpData()
    }
    
    loginRequest(with: data)
  }
  
  private func loginRequest(with data: [String: String]) {
    ServerManager.shared.authorize(login: submitFormButtonIsLogin(), data: data) { (success) in
      if success {
        DispatchQueue.main.async {
          self.showAuthorizationAlert(title: "Вы авторизованы", text: "Авторизация прошла успешно")
        }
      } else {
        DispatchQueue.main.async {
          self.showAuthorizationAlert(title: "Что-то пошло не так",
                                      text: "Проверьте правильность введенных данных. Если вы забыли пароль, то нажмите \"Напомнить пароль\" или создайте новый акккаунт.")
        }
      }
    }
  }
  
  private func showAuthorizationAlert(title: String, text: String) {
    let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Ок", style: .default, handler: { action in
      self.loginInputContainerView.clearTextFields()
    })
    alert.addAction(alertAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  private func getValidLoginData() -> [String: String] {
    let email = loginInputContainerView.emailTextField.text!
    let password = loginInputContainerView.passwordTextField.text!
    let data = ["login": email, "password": password, "key": ApiKeys.token!]
    return data
  }
  
  private func getValidSignUpData() -> [String: String] {
    var data = [String: String]()
    
    data["key"] = ApiKeys.token!
    data["email"] = loginInputContainerView.getEmailTextFieldData()
    data["name"] = loginInputContainerView.getNameTextFieldHandledData()
    data["password"] = loginInputContainerView.getPasswordTextFieldData()
    
    if let phoneNumber = loginInputContainerView.phoneTextField.text, phoneNumber != "" {
      data["phone"] = loginInputContainerView.getPhoneNumberTextFieldHandledData()
    }
    
    return data
  }
  
  private func formIsValid() -> Bool {
    if submitFormButtonIsLogin() {
      return loginInputContainerView.emailTextField.isValid && loginInputContainerView.passwordTextField.isValid
    } else {
      var result = loginInputContainerView.emailTextField.isValid &&
        loginInputContainerView.nameTextField.isValid &&
        loginInputContainerView.phoneTextField.isValid &&
        loginInputContainerView.passwordTextField.isValid &&
        loginInputContainerView.repeatPasswordTextField.isValid
      result = result && (loginInputContainerView.passwordTextField.text == loginInputContainerView.repeatPasswordTextField.text)
      return result
    }
  }
  
  private func submitFormButtonIsLogin() -> Bool {
    return loginInputContainerView.loginButton.title == "Войти"
  }
  
  private func showAlertMessage() {
    let alert = UIAlertController(title: "Ошибка", message: "Вы ввели данные неверно. Пожалуйста, проверьте правильность введенных вами данных и попробуйте снова.", preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Хорошо", style: .default, handler: nil)
    alert.addAction(alertAction)
    present(alert, animated: true, completion: nil)
  }
  
  @objc
  private func changeFormMode() {
    loginInputContainerView.changeContainerViewMode()
    
    changeNavigationItemTitle()
    changeSwitchingModeButtonTitle()
    changeLayoutsOfContainerView()
  }
  
  @objc
  private func forgotPassword() {
    show(ForgotPasswordViewController(), sender: self)
  }
  
  @objc
  private func dismissController() {
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
  
}

extension AuthorizationViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if textField.isPhoneNumberField {
//      textField.handlePhoneNumberField(withReplacingString: string, in: range)
      let phoneNumber = (textField.text! as NSString).replacingCharacters(in: range, with: string)
      viewModel.update(phoneNumber: phoneNumber)
      return false
    }
    
    if (textField.isEmailField || textField.isNameField) && string == " " {
      return false
    }
    
    return textField.textLengthIsValid || string.count < 1
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.isValid {
      textField.changeAppearanceForValidField()
      textField.resignFirstResponder()
      return true
    }
    textField.changeAppearanceForInvalidField()
    return false
  }
  
  private func hideKeyboard() {
    loginInputContainerView.endEditing(true)
  }
  
  @objc
  private func hideKeyboardAction() {
    view.endEditing(true)
  }
  
}
