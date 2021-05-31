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
    GeometryReader { proxy in
      ScrollView {
        Text("Manager's Special")
          .font(.headline)
          .padding()

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
        LazyVStack(spacing: 15.0) {
          ForEach(rows) { $0 }
        }
      }
      .background(Color(.secondarySystemBackground))
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static let specials = PreviewData.lotsOfSpecials
  static let store = Store(
    canvasUnit: specials.canvasUnit,
    specials: specials.managerSpecials
  )
  static var previews: some View {
    Group {
      SpecialsView(store: ContentView_Previews.store)
      SpecialsView(store: ContentView_Previews.store)
        .colorScheme(.dark)
    }
  }
}
