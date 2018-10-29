//
//  FilterPriceTableViewCell.swift
//  App020g
//
//  Created by Юрий Истомин on 28/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class FilterParameterNameLabel: UILabel {
  
  init(text: String, isMainTitle: Bool) {
    super.init(frame: .zero)
    
    setupLabel(withText: text)
    setFont(forMainTitle: isMainTitle)
  }
  
  private func setupLabel(withText text: String) {
    self.text = text
    textColor = ApplicationColors.buttonBlue
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
  }
  
  private func setFont(forMainTitle: Bool) {
    font = forMainTitle ? UIFont.systemFont(ofSize: 17) : UIFont.systemFont(ofSize: 14, weight: .light)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class FilterPriceTableViewCell: UITableViewCell {
  
  var priceRange: (min: Int, max: Int)? {
    didSet {
      if let priceRange = priceRange {
        setPriceRangeToTextFieldPlaceholders(priceRange)
      }
    }
  }
  
  private func setPriceRangeToTextFieldPlaceholders(_ priceRange: (Int, Int)) {
    priceFromTextField.placeholder = "\(priceRange.0)"
    priceToTextField.placeholder = "\(priceRange.1)"
  }
  
  private let parameterNameTextLabel = FilterParameterNameLabel(text: "Цена", isMainTitle: true)
  
  private let fromLabel = FilterParameterNameLabel(text: "от", isMainTitle: false)
  private let toLabel: FilterParameterNameLabel = {
    let label = FilterParameterNameLabel(text: "до", isMainTitle: false)
    label.textAlignment = .right
    return label
  }()
  
  private let priceFromTextField: UITextField = {
    let tf = UITextField(frame: .zero)
    tf.textAlignment = .right
    tf.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return tf
  }()
  
  private let priceFromTextFieldUnderline: UIView = {
    let view = UIView()
    view.backgroundColor = ApplicationColors.buttonBlue
    view.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return view
  }()
  
  private let priceToTextField: UITextField = {
    let tf = UITextField(frame: .zero)
    tf.textAlignment = .right
    tf.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return tf
  }()
  
  private let priceToTextFieldUnderline: UIView = {
    let view = UIView()
    view.backgroundColor = ApplicationColors.buttonBlue
    view.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubviews(parameterNameTextLabel,
                fromLabel, priceFromTextField, priceFromTextFieldUnderline,
                toLabel, priceToTextField, priceToTextFieldUnderline)
    setConstraintsToSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraintsToSubviews() {
    parameterNameTextLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    parameterNameTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
    parameterNameTextLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
    parameterNameTextLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    
    fromLabel.leftAnchor.constraint(equalTo: parameterNameTextLabel.leftAnchor).isActive = true
    fromLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
    fromLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
    fromLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    priceFromTextField.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 8).isActive = true
    priceFromTextField.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
    priceFromTextField.widthAnchor.constraint(equalToConstant: 65).isActive = true
    priceFromTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
    
    priceFromTextFieldUnderline.centerXAnchor.constraint(equalTo: priceFromTextField.centerXAnchor).isActive = true
    priceFromTextFieldUnderline.topAnchor.constraint(equalTo: priceFromTextField.bottomAnchor).isActive = true
    priceFromTextFieldUnderline.widthAnchor.constraint(equalToConstant: 80).isActive = true
    priceFromTextFieldUnderline.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    priceToTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    priceToTextField.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
    priceToTextField.widthAnchor.constraint(equalToConstant: 70).isActive = true
    priceToTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
    
    priceToTextFieldUnderline.centerXAnchor.constraint(equalTo: priceToTextField.centerXAnchor).isActive = true
    priceToTextFieldUnderline.topAnchor.constraint(equalTo: priceToTextField.bottomAnchor).isActive = true
    priceToTextFieldUnderline.widthAnchor.constraint(equalToConstant: 80).isActive = true
    priceToTextFieldUnderline.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    toLabel.rightAnchor.constraint(equalTo: priceToTextField.leftAnchor, constant: -16).isActive = true
    toLabel.bottomAnchor.constraint(equalTo: fromLabel.bottomAnchor).isActive = true
    toLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
    toLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
  }
}
