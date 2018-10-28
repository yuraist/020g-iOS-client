//
//  FilterParameterTableViewCell.swift
//  App020g
//
//  Created by Юрий Истомин on 25/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class FilterParameterTableViewCell: UITableViewCell {
  
  var filterParameter: FilterParameter? {
    didSet {
      clearCell()
      setupCell()
    }
  }
  
  private func clearCell() {
    
  }
  
  private func setupCell() {
    
  }
}
