//
//  ViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    navigationItem.title = "0.20g - агрегатор №1"
  }
  
  
}

