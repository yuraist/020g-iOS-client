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

extension String {
  public func estimatedWidth() -> CGFloat {
    let textSize = (self as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
    return textSize.width + 45
  }
}
