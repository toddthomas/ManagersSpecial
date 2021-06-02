//
//  ProductTileViewModel.swift
//  ManagersSpecial
//
//  Created by Todd Thomas on 5/27/21.
//

import Foundation

struct ProductTileViewModel {
  let product: Product
  let pointsPerCanvasUnit: Float

  var displayName: String {
    product.displayName
  }

  var originalPrice: String? {
    product.originalPrice > product.price ? "$\(product.originalPrice)" : nil
  }

  var price: String {
    "$\(product.price)"
  }

  var imageUrl: URL {
    product.imageUrl
  }

  var widthInPoints: Float {
    Float(product.width) * pointsPerCanvasUnit
  }

  var heightInPoints: Float {
    Float(product.height) * pointsPerCanvasUnit
  }

  var aspectRatio: Float {
    Float(product.width) / Float(product.height)
  }
}
