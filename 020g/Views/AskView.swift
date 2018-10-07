//
//  AskView.swift
//  020g
//
//  Created by Юрий Истомин on 20/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class AskView: UIView {

  let nameInput = TitledInputView(placeholder: "Чтобы знать как к Вам обращаться", title: "Имя")
  let phoneInput = TitledInputView(placeholder: "Необязательно, но оперативнее", title: "Телефон")
  let emailInput = TitledInputView(placeholder: "Сюда мы отправим ответ на вопрос", title: "Email")
  
  let textViewTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = ApplicationColors.darkGray
    label.text = "Текст сообщения"
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let textView: UITextView = {
    let tv = UITextView()
    tv.textColor = ApplicationColors.lightGray
    tv.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    tv.translatesAutoresizingMaskIntoConstraints = false
    return tv
  }()
  
  let sendButton = StandardButton(title: "Отправить вопрос")
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupContainerView()
    
    // Add subviews
    addSubview(nameInput)
    addSubview(phoneInput)
    addSubview(emailInput)
    addSubview(textViewTitleLabel)
    addSubview(textView)
    addSubview(sendButton)
    
    // Setup views layout constraints
    // Setup nameTextField layout constraints
    nameInput.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    nameInput.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
    nameInput.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
    nameInput.heightAnchor.constraint(equalToConstant: 52).isActive = true
    
    // Setup layout constraints for phoneTextField and emailTextField
    addDefaultConstraints(toView: phoneInput, relatedTo: nameInput)
    addDefaultConstraints(toView: emailInput, relatedTo: phoneInput)
    
    // Setup layout constraints for textiViewTitleLabel
    textViewTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    textViewTitleLabel.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: 4).isActive = true
    textViewTitleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
    textViewTitleLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    
    // Setup layout constraints for textView
    textView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    textView.topAnchor.constraint(equalTo: textViewTitleLabel.bottomAnchor, constant: 8).isActive = true
    textView.widthAnchor.constraint(equalTo: emailInput.widthAnchor).isActive = true
    textView.heightAnchor.constraint(equalToConstant: 90).isActive = true
    
    // Setup layout constraints for sendButton
    addDefaultInputConstraints(toView: sendButton, relatedTo: textView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupContainerView() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = ApplicationColors.white
    layer.cornerRadius = 5
    layer.shadowColor = UIColor(white: 0, alpha: 1).cgColor
    layer.shadowOpacity = 0.16
    layer.shadowRadius = 6
    layer.shadowOffset = CGSize(width: 0, height: 0)
  }
}
