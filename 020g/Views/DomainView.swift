//
//  DomainView.swift
//  020g
//
//  Created by Юрий Истомин on 02/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class DomainView: UIView {
  
  private var domain: String?
  
  private lazy var domainLabel: UILabel = {
    let domainLabel = UILabel()
    domainLabel.text = domain
    domainLabel.textColor = ApplicationColors.darkGray
    domainLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    domainLabel.translatesAutoresizingMaskIntoConstraints = false
    return domainLabel
  }()
  
  private let contactsLabel: UILabel = {
    let contactsLabel = UILabel()
    contactsLabel.text = "КОНТАКТЫ"
    contactsLabel.textColor = ApplicationColors.midBlue
    contactsLabel.translatesAutoresizingMaskIntoConstraints = false
    return contactsLabel
  }()
  
  private let separatorLineView: UIView = {
    let view = UIView()
    view.backgroundColor = ApplicationColors.lightGray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  init(withDomain domain: String?) {
    super.init(frame: .zero)
    setDomain(domain: domain)
    addLabels()
    setupLabelsConstraints()
    addSeparatorView()
    setupSeparatorViewConstraints()
  }
  
  func setDomain(domain: String?) {
    self.domain = domain
  }
  
  private func addLabels() {
    addSubview(domainLabel)
    addSubview(contactsLabel)
  }
  
  private func setupLabelsConstraints() {
    domainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    domainLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    domainLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
    domainLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    contactsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    contactsLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    contactsLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
    contactsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
  }
  
  private func addSeparatorView() {
    addSubview(separatorLineView)
  }
  
  private func setupSeparatorViewConstraints() {
    separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    separatorLineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
    separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

