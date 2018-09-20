//
//  AskViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class AskViewController: UIViewController {
  
  let inputContainerView: AskView = {
    let view = AskView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Задать вопрос"
    
    view.backgroundColor = ApplicationColor.gray
    view.addSubview(inputContainerView)
    
    inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    inputContainerView.widthAnchor.constraint(equalToConstant: 304).isActive = true
    inputContainerView.heightAnchor.constraint(equalToConstant: 500).isActive = true
  }
  
}
