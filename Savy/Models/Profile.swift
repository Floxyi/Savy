//
//  Profile.swift
//  Savy
//
//  Created by Florian Winkler on 02.09.24.
//

import Foundation

struct Profile: Codable {
  let username: String?
  let fullName: String?
  let website: String?

  enum CodingKeys: String, CodingKey {
    case username
    case fullName = "full_name"
    case website
  }
}
