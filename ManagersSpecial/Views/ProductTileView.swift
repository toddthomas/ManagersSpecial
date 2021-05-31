//
//  ProductTileView.swift
//  ManagersSpecial
//
//  Created by Todd Thomas on 5/27/21.
//

import SDWebImageSwiftUI
import SwiftUI

struct ProductTileView: View {
  let viewModel: ProductTileViewModel

  var body: some View {
    VStack {
      HStack {
        WebImage(url: viewModel.imageUrl)
          .resizable()
          .placeholder {
            Image(systemName: "photo")
              .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
          }
          .indicator(.activity)
          .scaledToFit()
        Spacer()
        VStack {
          viewModel.originalPrice.map {
            Text($0)
              .strikethrough()
              .font(.title)
              .fontWeight(.medium)
              .foregroundColor(.gray)
          }
          Text(viewModel.price)
            .font(.title)
            .fontWeight(.medium)
            .foregroundColor(.accentColor)
        }
        .layoutPriority(1)
      }
      .padding([.top, .leading, .trailing])
      Spacer()
      Text(viewModel.displayName)
        .multilineTextAlignment(.center)
        .padding([.bottom, .leading, .trailing])
        .layoutPriority(2)
    }
    .frame(
      height: CGFloat(viewModel.heightInPixels)
    )
    .aspectRatio(CGFloat(viewModel.aspectRatio), contentMode: .fit)
    .background(Color(.systemBackground))
    .cornerRadius(10.0)
    .shadow(radius: 10)
  }
}

struct ProductTileView_Previews: PreviewProvider {
  static let discountedProduct = Product(
    displayName: "Noodle Dish with Roasted Black Bean Sauce",
    height: 8,
    imageUrl: URL(string: "https://example.org")!,
    originalPrice: "3.99",
    price: "2.99",
    width: 8
  )

  static let fullPriceProduct = Product(
    displayName: "Chiles",
    height: 8,
    imageUrl: URL(string: "https://example.org")!,
    originalPrice: "2.99",
    price: "2.99",
    width: 16
  )

  static let discountedViewModel = ProductTileViewModel(
    product: ProductTileView_Previews.discountedProduct,
    pointsPerCanvasUnit: 22.5
  )

  static let fullPriceViewModel = ProductTileViewModel(
    product: ProductTileView_Previews.fullPriceProduct,
    pointsPerCanvasUnit: 22.5
  )

  static let narrowViewModel = ProductTileViewModel(
    product: PreviewData.narrowProduct,
    pointsPerCanvasUnit: 22.5
  )

  static let verySmallViewModel = ProductTileViewModel(
    product: PreviewData.verySmallProduct,
    pointsPerCanvasUnit: 22.5
  )

  static var previews: some View {
    Group {
      ProductTileView(
        viewModel: ProductTileView_Previews.discountedViewModel
      )
      ProductTileView(
        viewModel: ProductTileView_Previews.fullPriceViewModel
      )
      ProductTileView(
        viewModel: ProductTileView_Previews.narrowViewModel
      )
      ProductTileView(
        viewModel: ProductTileView_Previews.verySmallViewModel
      )
    }
  }
}
