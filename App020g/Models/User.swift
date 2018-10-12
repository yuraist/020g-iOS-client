//
//  User.swift
//  020g
//
//  Created by Юрий Истомин on 05/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

struct User: Codable {
  var name: String
  var phone: String?
  var email: String
  var pay: String
}

struct Users: Codable {
  var user: User
}
