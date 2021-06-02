//
//  SpecialsView.swift
//  ManagersSpecial
//
//  Created by Todd Thomas on 5/24/21.
//

import SwiftUI

struct SpecialsView: View {
  @ObservedObject var store: Store

  var body: some View {
    if let _ = store.error {
      VStack {
        AppTitleView()
        Spacer()
        VStack(spacing: 20.0) {
          VStack(spacing: 10.0) {
            Image(systemName: "exclamationmark.icloud")
              .font(.title)
            Text(
              "There was a problem downloading the specials. Please check your network settings."
            )
            .multilineTextAlignment(.center)
            .padding(.horizontal)
          }
          Button("Try Again") {
            self.store.update()
          }
        }
        Spacer()
      }
    } else {
      GeometryReader { proxy in
        ScrollView {
          AppTitleView()

          let pointsPerCanvasUnit =
            Float(proxy.size.width) / Float(store.canvasUnit)
          let rows =
            store.specials.chunkedByReduction(into: 0) { (sum, elem) in
              sum += elem.width
              return sum <= store.canvasUnit
            }.map {
              TileRowView(
                products: [Product]($0),
                pointsPerCanvasUnit: pointsPerCanvasUnit
              )
            }
          LazyVStack {
            ForEach(rows) { $0 }
          }
        }
      }
      .padding(.bottom)
      .background(Color(.secondarySystemBackground))
      .edgesIgnoringSafeArea(.bottom)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static let specials = PreviewData.lotsOfSpecials
  static let store = Store(
    canvasUnit: specials.canvasUnit,
    specials: specials.managerSpecials
  )
  static let storeWithError = Store(
    error: ManagersSpecialService.Error.network("network goof")
  )
  static var previews: some View {
    Group {
      SpecialsView(store: ContentView_Previews.store)
      SpecialsView(store: ContentView_Previews.store)
        .colorScheme(.dark)
      SpecialsView(store: ContentView_Previews.storeWithError)
    }
  }
}
