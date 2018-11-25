//
//  ProductDetailCell.swift
//  020g
//
//  Created by Юрий Истомин on 09/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ProductDetailCell: UITableViewCell {
  
  var option: Option? {
    didSet {
      clearCell()
      setupCell()
    }
  }
  
  let detailNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = ApplicationColors.darkGray
    label.font = .systemFont(ofSize: 15, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let verticalSeparatorLine: UIView = {
    let view = UIView()
    view.backgroundColor = ApplicationColors.gray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let horizontalSeparatorLine: UIView = {
    let view = UIView()
    view.backgroundColor = ApplicationColors.gray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let detailInfoLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 15, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .none
    addLabels()
    setupLabelConstraints()
  }
  
  private func addLabels() {
    addSubview(detailNameLabel)
    addSubview(verticalSeparatorLine)
    addSubview(detailInfoLabel)
    addSubview(horizontalSeparatorLine)
  }
  
  private func setupLabelConstraints() {
    detailNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    detailNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    detailNameLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
    detailNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    verticalSeparatorLine.leftAnchor.constraint(equalTo: detailNameLabel.rightAnchor, constant: 4).isActive = true
    verticalSeparatorLine.topAnchor.constraint(equalTo: topAnchor).isActive = true
    verticalSeparatorLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
    verticalSeparatorLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    
    detailInfoLabel.leftAnchor.constraint(equalTo: verticalSeparatorLine.rightAnchor, constant: 8).isActive = true
    detailInfoLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    detailInfoLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    detailInfoLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    horizontalSeparatorLine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    horizontalSeparatorLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    horizontalSeparatorLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    horizontalSeparatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
  }
  
  private func clearCell() {
    detailNameLabel.text = ""
    detailInfoLabel.text = ""
  }
  
  private func setupCell() {
    if let option = option {
      detailNameLabel.text = option.name
      detailInfoLabel.text = option.value
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
