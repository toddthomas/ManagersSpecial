//
//  ProductModelTests.swift
//  ManagersSpecialTests
//
//  Created by Todd Thomas on 5/24/21.
//

import XCTest
@testable import ManagersSpecial

class ProductModelTests: XCTestCase {
  func testProduct() throws {
    guard let product: Product = BundleHelpers.modelFromJsonFile(
      named: "product"
    ) else {
      XCTFail("Expected to parse a product from product.json.")
      return
    }

    XCTAssertEqual(product.displayName, "Noodle Dish with Roasted Black Bean Sauce")
    XCTAssertEqual(product.height, 8)
    XCTAssertEqual(product.width, 16)
    XCTAssertEqual(product.imageUrl, URL(string: "https://raw.githubusercontent.com/prestoqinc/code-exercise-ios/master/images/L.png")!)
    XCTAssertEqual(product.originalPrice, "2.00")
    XCTAssertEqual(product.price, "1.00")
  }
}
