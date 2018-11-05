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
    
    bindTextFields()
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
  
  
  @objc
  private func login() {
    let type: FormType = submitFormButtonIsLogin() ? .signIn : .signUp
    
    switch viewModel.validate(formOfType: type) {
    case .valid:
      hideKeyboard()
      prepareDataAndSendLoginRequest()
    case .invalid(let error):
      showAuthorizationAlert(title: "Ошибка", text: error)
    }
  }
  
  private func prepareDataAndSendLoginRequest() {
    if submitFormButtonIsLogin() {
      viewModel.login { [unowned self] (success) in
        DispatchQueue.main.async {
          if success {
            self.showSuccessAuthorizationAlert()
          } else {
            self.showFailureAuthorizationAlert()
          }
        }
      }
    } else {
      viewModel.signUp { (success) in
        DispatchQueue.main.async {
          if success {
            self.showSuccessAuthorizationAlert()
          } else {
            self.showFailureAuthorizationAlert()
          }
        }
      }
    }
  }
  
  private func showSuccessAuthorizationAlert() {
    self.showAuthorizationAlert(title: "Вы авторизованы", text: "Авторизация прошла успешно")
  }
  
  private func showFailureAuthorizationAlert() {
    self.showAuthorizationAlert(title: "Что-то пошло не так",
                                text: "Проверьте правильность введенных данных. Если вы забыли пароль, то нажмите \"Напомнить пароль\" или создайте новый акккаунт.")
  }
  
  private func addHideKeyboardActionWhenTappedOutsideInputContainer() {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardAction))
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc
  private func hideKeyboardAction() {
    view.endEditing(true)
  }
  
  private func bindTextFields() {
    viewModel.phoneNumber.bind { [unowned self] in
      self.loginInputContainerView.phoneTextField.text = $0
    }
    
    viewModel.email.bind { [unowned self] in
      self.loginInputContainerView.emailTextField.text = $0
    }
    
    viewModel.name.bind { [unowned self] in
      self.loginInputContainerView.nameTextField.text = $0
    }
    
    viewModel.password.bind { [unowned self] in
      self.loginInputContainerView.passwordTextField.text = $0
    }
    
    viewModel.repeatPassword.bind { [unowned self] in
      self.loginInputContainerView.repeatPasswordTextField.text = $0
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
  
  private func submitFormButtonIsLogin() -> Bool {
    return loginInputContainerView.loginButton.title == "Войти"
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
    
    let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    
    if textField.isPhoneNumberField {
      viewModel.update(phoneNumber: newString)
    } else if textField.isEmailField {
      viewModel.update(email: newString)
    } else if textField.isNameField {
      viewModel.update(name: newString)
    } else if textField.isPasswordField {
      viewModel.update(password: newString)
    } else {
      viewModel.update(repeatedPassword: newString)
    }
    
    return false
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
  
}
