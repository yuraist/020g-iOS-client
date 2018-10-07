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
    setGrayBackgroundColor()
    addInputContainerView()
    setupConstraintsForInputContainerView()
    addHideKeyboardOnTapGestureAction()
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
}

extension AskViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.isValid {
      textField.changeAppearanceForValidField()
      textField.resignFirstResponder()
    } else {
      textField.changeAppearanceForInvalidField()
    }
    return textField.isValid
  }
}
