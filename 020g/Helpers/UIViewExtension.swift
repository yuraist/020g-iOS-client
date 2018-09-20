//
//  UIViewExtension.swift
//  020g
//
//  Created by Юрий Истомин on 20/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

extension UIView {
  func addDefaultConstraints(toView view: UIView, relatedTo previous: UIView) {
    view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    view.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 8).isActive = true
    view.widthAnchor.constraint(equalTo: previous.widthAnchor).isActive = true
    view.heightAnchor.constraint(equalTo: previous.heightAnchor).isActive = true
  }
  
  func addDefaultInputConstraints(toView view: UIView, relatedTo previous: UIView) {
    view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    view.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 8).isActive = true
    view.widthAnchor.constraint(equalTo: previous.widthAnchor).isActive = true
    view.heightAnchor.constraint(equalToConstant: 32).isActive = true
  }
}
