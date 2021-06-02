//
//  ProductImageView.swift
//  ManagersSpecial
//
//  Created by Todd Thomas on 6/1/21.
//

import SDWebImageSwiftUI
import SwiftUI

struct ProductImageView: View {
  let url: URL
  
  var body: some View {
    WebImage(url: url)
      .resizable()
      .placeholder {
        Image(systemName: "photo")
          .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
      }
      .indicator(.activity)
      .scaledToFit()
  }
}

struct ProductImageView_Previews: PreviewProvider {
  static var previews: some View {
    ProductImageView(url: URL(string: "http://example.org")!)
  }
}
