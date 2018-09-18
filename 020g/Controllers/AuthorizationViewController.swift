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
    
    loginInputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
    loginInputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    loginInputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
    loginInputContainerView.heightAnchor.constraint(equalToConstant: LoginInputContainerView.loginHeight).isActive = true
    
  }
  
  @objc private func dismissController() {
    dismiss(animated: true, completion: nil)
  }
}
