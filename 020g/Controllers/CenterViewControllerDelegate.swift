//
//  CenterViewControllerDelegate.swift
//  020g
//
//  Created by Юрий Истомин on 21/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
  @objc optional func toggleLeftPanel()
  @objc optional func collapseSidePannel()
}
