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
    setupNavigationItem()
    setupNavigationControllerStyle()
    
    view.backgroundColor = ApplicationColors.gray
    view.addSubview(inputContainerView)
    
    inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    inputContainerView.widthAnchor.constraint(equalToConstant: 304).isActive = true
    inputContainerView.heightAnchor.constraint(equalToConstant: 370).isActive = true
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
  
  @objc private func dismissController() {
    dismiss(animated: true, completion: nil)
  }
}
