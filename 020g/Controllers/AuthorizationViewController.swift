//
//  AuthorizationViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController {
  
  let loginInputContainerView = LoginInputContainerView(frame: .zero)
  var loginInputContainerViewHeightAnchor: NSLayoutConstraint?
  
  private func setupNavigationControllerStyle() {
    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
      navigationController?.navigationItem.largeTitleDisplayMode = .automatic
      navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ApplicationColor.white] as [NSAttributedString.Key: Any]
    }
    
    navigationController?.navigationBar.barTintColor = ApplicationColor.darkBlue
    navigationController?.navigationBar.tintColor = ApplicationColor.white
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ApplicationColor.white] as [NSAttributedString.Key: Any]
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissController))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationControllerStyle()
    navigationItem.title = "Войти"
    
    view.backgroundColor = ApplicationColor.gray
    view.addSubview(loginInputContainerView)
    
    loginInputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    loginInputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    loginInputContainerView.widthAnchor.constraint(equalToConstant: 304).isActive = true
    loginInputContainerViewHeightAnchor = loginInputContainerView.heightAnchor.constraint(equalToConstant: LoginInputContainerView.loginHeight)
    loginInputContainerViewHeightAnchor?.isActive = true
    
    loginInputContainerView.loginButton.addTarget(self, action: #selector(changeFormMode), for: .touchUpInside)
  }
  
  @objc private func changeFormMode() {
    // Change the navigation bar title
    navigationItem.title = loginInputContainerView.isSignUpView ? "Регистрация" : "Вход"
    
    // Change the form mode for all inputs
    loginInputContainerView.isSignUpView = !loginInputContainerView.isSignUpView
    
    // Change layouts of the container
    loginInputContainerViewHeightAnchor?.isActive = false
    loginInputContainerViewHeightAnchor = loginInputContainerView.heightAnchor.constraint(equalToConstant: loginInputContainerView.isSignUpView ? LoginInputContainerView.signUpHeight : LoginInputContainerView.loginHeight)
    loginInputContainerViewHeightAnchor?.isActive = true
  }
  
  @objc private func dismissController() {
    dismiss(animated: true, completion: nil)
  }
}
