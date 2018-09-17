//
//  Helpers.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

extension UIColor {
  public static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
  }
}

enum ApplicationColor {
  static let darkBlue = UIColor.rgb(71, 82, 162)
  static let midBlue = UIColor.rgb(82, 106, 192)
  static let violet = UIColor.rgb(157, 167, 218)
  static let gray = UIColor.rgb(240, 240, 240)
  static let white = UIColor.white
}
