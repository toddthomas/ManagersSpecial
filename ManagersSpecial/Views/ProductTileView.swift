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
  let spacing: CGFloat = 5.0
  let smallWidth: Float = 135.0
  let verySmallWidth: Float = 75.0

  var body: some View {
    GeometryReader { geometry in
      VStack {
        VStack {
          if viewModel.widthInPoints < verySmallWidth {
            // Too narrow for price or description text. Show only the image.
            ProductImageView(url: viewModel.imageUrl)
              .cornerRadius(10.0)
          } else {
            // Always show price and description text, though possibly at a very
            // small size. Also show product image if there's enough room.
            HStack {
              if viewModel.widthInPoints > smallWidth {
                ProductImageView(url: viewModel.imageUrl)

                Spacer()
              }

              VStack {
                let priceFont: Font = viewModel.widthInPoints > smallWidth ? .title2 : .footnote

                viewModel.originalPrice.map {
                  Text($0)
                    .strikethrough()
                    .font(priceFont)
                    .fontWeight(.medium)
                    .allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.gray)
                }

                Text(viewModel.price)
                  .font(priceFont)
                  .fontWeight(.medium)
                  .allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                  .foregroundColor(.accentColor)
              }
              .layoutPriority(1)
            }
            .padding([.top, .leading, .trailing])

            Spacer()

            let nameFont: Font = viewModel.widthInPoints > smallWidth ? .body : .caption2
            Text(viewModel.displayName)
              .font(nameFont)
              .allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
              .multilineTextAlignment(.center)
              .padding([.bottom, .leading, .trailing])
              .layoutPriority(2)

            Spacer()
          }
        }
        .frame(
          width: geometry.size.width - (spacing * 2),
          height: geometry.size.height - (spacing * 2)
        )
        .background(Color(.systemBackground))
        .cornerRadius(10.0)
        .shadow(radius: 10)
      }
      // This frame and the `VStack` it modifies exist solely to recenter the
      // above views within the outer `GeometryReader`. See
      // https://swiftui-lab.com/geometryreader-bug/.
      .frame(
        width: geometry.size.width,
        height: geometry.size.height,
        alignment: .center
      )
    }
    .frame(
      width: CGFloat(viewModel.widthInPoints),
      height: CGFloat(viewModel.heightInPoints)
    )
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(Text(viewModel.accessibilityLabelText))
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
