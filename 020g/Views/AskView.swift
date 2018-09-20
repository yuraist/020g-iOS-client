//
//  AskView.swift
//  020g
//
//  Created by Юрий Истомин on 20/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class AskView: UIView {

  let nameTextField = TitledInputView(placeholder: "Чтобы знать как к Вам обращаться", title: "Имя")
  let phoneTextField = TitledInputView(placeholder: "Необязательно, но оперативнее", title: "Телефон")
  let emailTextField = TitledInputView(placeholder: "Сюда мы отправим ответ на вопрос", title: "Email")
  
  let textView: UITextView = {
    let tv = UITextView()
    tv.text = "Текст сообщения"
    tv.textColor = ApplicationColor.lightGray
    tv.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    tv.translatesAutoresizingMaskIntoConstraints = false
    return tv
  }()
  
  let sendButton = StandardButton(title: "Отправить вопрос")
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupContainerView()
    
    // Add subviews
    addSubview(nameTextField)
    addSubview(phoneTextField)
    addSubview(emailTextField)
    addSubview(textView)
    addSubview(sendButton)
    
    // Setup views layout constraints
    // Setup nameTextField layout constraints
    nameTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    nameTextField.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
    nameTextField.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
    nameTextField.heightAnchor.constraint(equalToConstant: 52).isActive = true
    
    // Setup layout constraints for phoneTextField and emailTextField
    addDefaultConstraints(toView: phoneTextField, relatedTo: nameTextField)
    addDefaultConstraints(toView: emailTextField, relatedTo: phoneTextField)
    
    // Setup layout constraints for textView
    textView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    textView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8).isActive = true
    textView.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
    textView.heightAnchor.constraint(equalToConstant: 244).isActive = true
    
    // Setup layout constraints for sendButton
    addDefaultInputConstraints(toView: sendButton, relatedTo: textView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupContainerView() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = ApplicationColor.white
    layer.cornerRadius = 5
    layer.shadowColor = UIColor(white: 0, alpha: 1).cgColor
    layer.shadowOpacity = 0.16
    layer.shadowRadius = 6
    layer.shadowOffset = CGSize(width: 0, height: 0)
  }
}
