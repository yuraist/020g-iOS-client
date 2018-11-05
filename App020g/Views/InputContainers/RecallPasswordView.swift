//
//  RecallPasswordView.swift
//  020g
//
//  Created by Юрий Истомин on 20/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class RecallPasswordView: UIView {

  let messageLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.font = UIFont.systemFont(ofSize: 15)
    label.textColor = ApplicationColors.lightGray
    label.text = "Укажите Ваш Email для восстановления пароля"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let emailTextField: TextField = {
    let tf = TextField(placeholder: "Email", isSecureTextEntry: false)
    return tf
  }()
  
  let separatorView = SeparatorView()
  
  let recallButton: StandardButton = {
    let button = StandardButton(title: "Отправить")
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupContainerViewAppearance()
    addSubviews()
    setupConstraintsOfSubviews()
  }
  
  private func setupContainerViewAppearance() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = ApplicationColors.white
    layer.cornerRadius = 5
    layer.shadowColor = UIColor(white: 0, alpha: 1).cgColor
    layer.shadowOpacity = 0.16
    layer.shadowRadius = 6
    layer.shadowOffset = CGSize(width: 0, height: 0)
  }
  
  private func addSubviews() {
    addSubview(messageLabel)
    addSubview(emailTextField)
    addSubview(separatorView)
    addSubview(recallButton)
  }
  
  private func setupConstraintsOfSubviews() {
    // Setup messageLabel layout constraints
    messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
    messageLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
    messageLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    // Setup emailTextField layout constraints
    emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    emailTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    emailTextField.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
    emailTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
    
    // Setup separatorView
    separatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    separatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: -1).isActive = true
    separatorView.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
    separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    // Setup recallButton layout constraints
    recallButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    recallButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
    recallButton.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
    recallButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
