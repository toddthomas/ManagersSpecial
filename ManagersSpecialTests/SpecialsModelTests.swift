//
//  SpecialsModelTests.swift
//  ManagersSpecialTests
//
//  Created by Todd Thomas on 5/27/21.
//

import XCTest
@testable import ManagersSpecial

class SpecialsModelTests: XCTestCase {
  func testSpecials() throws {
    guard let specials: Specials = BundleHelpers.modelFromJsonFile(
      named: "specials"
    ) else {
      XCTFail("Expected to parse specials from specials.json.")
      return
    }

    XCTAssertEqual(specials.canvasUnit, 16)

    let expectedDisplayNames = [
      "Noodle Dish with Roasted Black Bean Sauce",
      "Onion Flavored Rings",
      "Kikkoman Less Sodium Soy Sauce"
    ]
    XCTAssertEqual(expectedDisplayNames, specials.managerSpecials.map(\.displayName))
  }
}
