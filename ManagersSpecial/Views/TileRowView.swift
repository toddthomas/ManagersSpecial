//
//  TileRowView.swift
//  ManagersSpecial
//
//  Created by Todd Thomas on 5/28/21.
//

import SwiftUI

struct TileRowView: View, Identifiable {
  let products: [Product]
  let pointsPerCanvasUnit: Float

  // TODO: `TileRowView`s are passed in a collection to `ForEach` in a SwiftUI
  // view, so they need to be `Identifiable`. I need to research whether the ID
  // needs to be essentially a hash of the view's properties in order for
  // SwiftUI to update views most efficiently.
  var id = UUID()

  var body: some View {
    HStack(spacing: 0) {
      ForEach(products) {
        ProductTileView(
          viewModel: ProductTileViewModel(
            product: $0,
            pointsPerCanvasUnit: pointsPerCanvasUnit
          )
        )
      }
    }
    .padding(.horizontal)
  }
}

struct TileRowView_Previews: PreviewProvider {
  static let products = [
    Product(
      displayName: "Noodle Dish with Roasted Black Bean Sauce",
      height: 8,
      imageUrl: URL(string: "https://example.org")!,
      originalPrice: "3.99",
      price: "2.99",
      width: 8
    ),
    Product(
      displayName: "Noodle Dish with Roasted Black Bean Sauce",
      height: 8,
      imageUrl: URL(string: "https://example.org")!,
      originalPrice: "3.99",
      price: "2.99",
      width: 8
    ),
  ]

  static var previews: some View {
    Group {
      TileRowView(
        products: TileRowView_Previews.products,
        pointsPerCanvasUnit: 24.375
      )
      TileRowView(
        products: PreviewData.threeSameOneTallerProducts,
        pointsPerCanvasUnit: 24.375
      )
    }
  }
}
