//
//  ProductTileViewModelTests.swift
//  ManagersSpecialTests
//
//  Created by Todd Thomas on 5/28/21.
//

import XCTest
@testable import ManagersSpecial

class ProductTileViewModelTests: XCTestCase {
  let discountedProduct = Product(
    displayName: "Canteloupe",
    height: 8,
    imageUrl: URL(string: "https://example.org")!,
    originalPrice: "2.99",
    price: "1.99",
    width: 16
  )

  let fullPriceProduct = Product(
    displayName: "Canteloupe",
    height: 8,
    imageUrl: URL(string: "https://example.org")!,
    originalPrice: "1.99",
    price: "1.99",
    width: 16
  )

  func testDiscountedProduct() throws {
    let viewModel = ProductTileViewModel(
      product: discountedProduct,
      pointsPerCanvasUnit: 24.375
    )

    XCTAssertEqual(viewModel.originalPrice!, "$2.99")
    XCTAssertEqual(viewModel.price, "$1.99")

    let expectedAccessibilityLabelText =
      """
      Canteloupe. Regular price $2.99, now $1.99
      """
    XCTAssertEqual(
      viewModel.accessibilityLabelText,
      expectedAccessibilityLabelText
    )
  }

  func testFullPriceProduct() throws {
    let viewModel = ProductTileViewModel(
      product: fullPriceProduct,
      pointsPerCanvasUnit: 24.375
    )

    XCTAssertNil(viewModel.originalPrice)
    XCTAssertEqual(viewModel.price, "$1.99")

    let expectedAccessibilityLabelText =
      """
      Canteloupe. $1.99
      """
    XCTAssertEqual(
      viewModel.accessibilityLabelText,
      expectedAccessibilityLabelText
    )
  }

  func testDimensions() throws {
    let viewModel = ProductTileViewModel(
      product: discountedProduct,
      pointsPerCanvasUnit: 24.375
    )

    XCTAssertEqual(viewModel.widthInPoints, 390.0)
    XCTAssertEqual(viewModel.heightInPoints, 195.0)
    XCTAssertEqual(viewModel.aspectRatio, 2.0)
  }
}
