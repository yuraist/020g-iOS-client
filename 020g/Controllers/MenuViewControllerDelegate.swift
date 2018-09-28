//
//  MenuViewControllerDelegate.swift
//  020g
//
//  Created by Юрий Истомин on 28/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

@objc
protocol MenuViewControllerDelegate {
  @objc optional func didSelect(screen: String)
}
