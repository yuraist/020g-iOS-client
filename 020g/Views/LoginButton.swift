//
//  LoginButton.swift
//  020g
//
//  Created by Юрий Истомин on 19/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class LoginButton: UIButton {

  var title: String? {
    didSet {
      setTitle(title, for: .normal)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    title = "Войти"
    titleLabel?.font = UIFont.systemFont(ofSize: 15)
    tintColor = ApplicationColor.white
    backgroundColor = ApplicationColor.darkBlue
    layer.cornerRadius = 5
    layer.masksToBounds = true
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
