//
//  User.swift
//  Savy
//
//  Created by Florian Winkler on 29.08.24.
//

import Foundation

struct User: Decodable, Identifiable {
  let id: Int
  let name: String
}
