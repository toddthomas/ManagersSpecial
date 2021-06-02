//
//  Store.swift
//  ManagersSpecial
//
//  Created by Todd Thomas on 5/26/21.
//

import os
import Combine
import Foundation

class Store: ObservableObject {
  @Published var canvasUnit: Int
  @Published var specials: [Product]
  @Published var error: ManagersSpecialService.Error?

  init(
    canvasUnit: Int = 16,
    specials: [Product] = [],
    error: ManagersSpecialService.Error? = nil
  ) {
    self.canvasUnit = canvasUnit
    self.specials = specials
    self.error = error
  }

  private let service = ManagersSpecialService()
  private var subscriptions = Set<AnyCancellable>()
  private let logger = Logger()

  func update() {
    service
      .specials()
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          self.error = error

          let logMessage = "error fetching specials"
          switch error {
          case .network(let message):
            self.logger.log("\(logMessage): \(message)")
          case .parsing(let error):
            if let error = error {
              switch error {
              case .dataCorrupted(let context):
                self.logger.log("\(logMessage): data corrupted at \(context.codingPath)")
              case .typeMismatch(let type, let context):
                self.logger.log("\(logMessage): data at \(context.codingPath) not of type \(type)")
              case .valueNotFound(let type, let context):
                self.logger.log("\(logMessage): no \(type) at \(context.codingPath)")
              case .keyNotFound(let key, let context):
                self.logger.log("\(logMessage): no data with key \"\(key.stringValue)\" at \(context.codingPath)")
              @unknown default:
                self.logger.log("\(logMessage): unknown parsing error")
              }
            }
          case .unknown:
            self.logger.log("unknown \(logMessage)")
          }
        }
      }, receiveValue: { specials in
        self.canvasUnit = specials.canvasUnit
        self.specials = specials.managerSpecials
        self.error = nil
      })
      .store(in: &subscriptions)
  }
}
