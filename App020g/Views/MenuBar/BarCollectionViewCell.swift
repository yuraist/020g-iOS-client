//
//  BarCollectionViewCell.swift
//  020g
//
//  Created by Юрий Истомин on 24/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class BarCollectionViewCell: UICollectionViewCell {
  
  let textLabel: UILabel = {
    let label = UILabel()
    label.text = "Category"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 13)
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
  
  private let selectedCellTopLineView = SelectedCellLineView(frame: .zero)
  private let selectedCellBottomLineView = SelectedCellLineView(frame: .zero)
  
  var topLineHeightAnchor: NSLayoutConstraint?
  var bottomLineHeightAnchor: NSLayoutConstraint?
  
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
    addSubview(selectedCellTopLineView)
    addSubview(selectedCellBottomLineView)
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
    selectedCellTopLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    selectedCellTopLineView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    selectedCellTopLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    topLineHeightAnchor = selectedCellTopLineView.heightAnchor.constraint(equalToConstant: 0)
    topLineHeightAnchor?.isActive = true
  }
  
  private func setupSelectedViewBottomLineConstraints() {
    selectedCellBottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    selectedCellBottomLineView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    selectedCellBottomLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    bottomLineHeightAnchor = selectedCellBottomLineView.heightAnchor.constraint(equalToConstant: 0)
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
