//
//  PreviewData.swift
//  ManagersSpecial
//
//  Created by Todd Thomas on 5/31/21.
//

import Foundation

enum PreviewData {
  static var lotsOfSpecials: Specials {
    guard let specials: Specials = BundleHelpers.modelFromJsonFile(
      named: "specials"
    ) else {
      fatalError("Error parsing specials.json.")
    }

    return specials
  }

  static var narrowProduct: Product {
    guard let product: Product = BundleHelpers.modelFromJsonFile(
            named: "narrowProduct"
    ) else {
      fatalError("Error parsing narrowProduct.json")
    }

    return product
  }

  static var verySmallProduct: Product {
    guard let product: Product = BundleHelpers.modelFromJsonFile(
            named: "verySmallProduct"
    ) else {
      fatalError("Error parsing verySmallProduct.json")
    }

    return product
  }

  static var threeSameOneTallerProducts: [Product] {
    guard let products: [Product] = BundleHelpers.modelFromJsonFile(
            named: "threeSameOneTallerProducts"
    ) else {
      fatalError("Error parsing threeSameOneTallerProducts.json")
    }

    return products
  }
}
