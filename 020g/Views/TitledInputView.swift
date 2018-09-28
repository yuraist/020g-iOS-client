//
//  TitledTextField.swift
//  020g
//
//  Created by Юрий Истомин on 20/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class TitledInputView: UIView {

  let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = ApplicationColor.darkGray
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let textField: StandardTextField = {
    let tf = StandardTextField(placeholder: "Чтобы мы знали как к Вам обращаться", isSecureTextEntry: false)
    return tf
  }()
  
  let separatorLineView = SeparatorView()

  init(placeholder: String, title: String) {
    super.init(frame: .zero)
    addViewsAndSetup()
    titleLabel.text = title
    textField.placeholder = placeholder
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addViewsAndSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addViewsAndSetup() {
    translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(titleLabel)
    addSubview(textField)
    addSubview(separatorLineView)
    
    titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    titleLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    textField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
    textField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    textField.heightAnchor.constraint(equalToConstant: 32).isActive = true
    
    separatorLineView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    separatorLineView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: -1).isActive = true
    separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
  }
}
