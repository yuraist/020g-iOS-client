//
//  ForgotPasswordViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
  
  let inputContainerView: RecallPasswordView = {
    let recallView = RecallPasswordView(frame: .zero)
    recallView.translatesAutoresizingMaskIntoConstraints = false
    return recallView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Напомнить пароль"
    
    // Setup view's background color
    view.backgroundColor = ApplicationColor.gray
    
    view.addSubview(inputContainerView)
    
    inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    inputContainerView.widthAnchor.constraint(equalToConstant: 304).isActive = true
    inputContainerView.heightAnchor.constraint(equalToConstant: 168).isActive = true
  }
  
}
