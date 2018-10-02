//
//  MenuBarCollectionViewCell.swift
//  020g
//
//  Created by Юрий Истомин on 24/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class MenuBarCollectionViewCell: UICollectionViewCell {
  
  let textLabel: UILabel = {
    let label = UILabel()
    label.text = "Category"
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override var isSelected: Bool {
    didSet {
      if isSelected {
        showTopAndBottomLines()
      } else {
        hideTopAndBottomLines()
      }
    }
  }
  
  private let selectedCellTopLine: UIView = {
    let view = UIView()
    view.backgroundColor = ApplicationColors.darkBlue
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let selectedCellBottomLine: UIView = {
    let view = UIView()
    view.backgroundColor = ApplicationColors.darkBlue
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private var topLineHeightAnchor: NSLayoutConstraint?
  private var bottomLineHeightAnchor: NSLayoutConstraint?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setVioletBackgroundColor()
    addSubviews()
    setupSubviewsConstraints()
  }
  
  private func setVioletBackgroundColor() {
    backgroundColor = ApplicationColors.violet
  }
  
  private func addSubviews() {
    addSubview(textLabel)
    addSubview(selectedCellTopLine)
    addSubview(selectedCellBottomLine)
  }
  
  private func setupSubviewsConstraints() {
    setupTextLabelConstraints()
    setupSelectedViewTopLineConstraints()
    setupSelectedViewBottomLineConstraints()
  }
  
  private func setupTextLabelConstraints() {
    textLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    textLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    textLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
  }
  
  private func setupSelectedViewTopLineConstraints() {
    selectedCellTopLine.topAnchor.constraint(equalTo: topAnchor).isActive = true
    selectedCellTopLine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    selectedCellTopLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    topLineHeightAnchor = selectedCellTopLine.heightAnchor.constraint(equalToConstant: 0)
    topLineHeightAnchor?.isActive = true
  }
  
  private func setupSelectedViewBottomLineConstraints() {
    selectedCellBottomLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    selectedCellBottomLine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    selectedCellBottomLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    bottomLineHeightAnchor = selectedCellBottomLine.heightAnchor.constraint(equalToConstant: 0)
    bottomLineHeightAnchor?.isActive = true
  }
  
  private func showTopAndBottomLines() {
    changeHeightOfTopAndBottomLines(to: 4)
  }
  
  private func hideTopAndBottomLines() {
    changeHeightOfTopAndBottomLines(to: 0)
  }
  
  private func changeHeightOfTopAndBottomLines(to number: CGFloat) {
    topLineHeightAnchor?.constant = number
    bottomLineHeightAnchor?.constant = number
    animateLines()
  }
  
  private func animateLines() {
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
      self.layoutIfNeeded()
    }, completion: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
