//
//  AcceptFilterView.swift
//  App020g
//
//  Created by Юрий Истомин on 30/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class CustomLabeledImageView: UIView {
  
  private let imageView: UIImageView = {
    let iv = UIImageView()
    iv.tintColor = ApplicationColors.white
    iv.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return iv
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = ApplicationColors.white
    label.font = UIFont.systemFont(ofSize: 14)
    label.textAlignment = .left
    label.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return label
  }()
  
  init(withImage image: UIImage, andTitle title: String) {
    super.init(frame: .zero)
    
    backgroundColor = ApplicationColors.buttonBlue
    layer.cornerRadius = 3
    layer.masksToBounds = true
    
    imageView.image = image.withRenderingMode(.alwaysTemplate)
    titleLabel.text = title
    
    addSubviews(imageView, titleLabel)
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
    setConstraintsForSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraintsForSubviews() {
    titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 15).isActive = true
    titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    titleLabel.widthAnchor.constraint(equalToConstant: 66).isActive = true
    titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    imageView.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -8).isActive = true
    imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
  }
}

class AcceptFilterView: UIView {
  
  private let acceptView = CustomLabeledImageView(withImage: #imageLiteral(resourceName: "ok"), andTitle: "Готово")
  private let cancelView = CustomLabeledImageView(withImage: #imageLiteral(resourceName: "cancel"), andTitle: "Очистить")
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
    setWhiteBackgroundColor()
    addSubviews(acceptView, cancelView)
    setConstraintsForSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraintsForSubviews() {
    cancelView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    cancelView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    cancelView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -20).isActive = true
    cancelView.heightAnchor.constraint(equalToConstant: 36).isActive = true
    
    acceptView.leftAnchor.constraint(equalTo: cancelView.rightAnchor, constant: 8).isActive = true
    acceptView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    acceptView.widthAnchor.constraint(equalTo: cancelView.widthAnchor).isActive = true
    acceptView.heightAnchor.constraint(equalToConstant: 36).isActive = true
  }
}
