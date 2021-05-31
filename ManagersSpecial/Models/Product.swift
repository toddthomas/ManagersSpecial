//
//  Product.swift
//  ManagersSpecial
//
//  Created by Todd Thomas on 5/24/21.
//

import Foundation

struct Product: Identifiable, Codable {
  var id = UUID()

  let displayName: String
  let height: Int
  let imageUrl: URL
  let originalPrice: String
  let price: String
  let width: Int
}

extension Product {
  private enum CodingKeys: String, CodingKey {
    case displayName = "display_name"
    case height
    case imageUrl
    case originalPrice = "original_price"
    case price
    case width
  }
}
