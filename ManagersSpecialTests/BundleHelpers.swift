//
//  BundleHelpers.swift
//  ManagersSpecialTests
//
//  Created by Todd Thomas on 5/24/21.
//

import Foundation

public class BundleHelpers {
  public static func modelFromJsonFile<Model: Decodable>(named fileName: String) -> Model? {
    let bundle = Bundle(for: self)

    guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
      fatalError("Couldn't find file \(fileName).json.")
    }

    let data = try! Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try! decoder.decode(Model.self, from: data)
  }
}
