//
//  ManagersSpecialsService.swift
//  ManagersSpecial
//
//  Created by Todd Thomas on 5/26/21.
//

import Combine
import Foundation

struct ManagersSpecialService {
  enum Error: LocalizedError {
    case network(String)
    case parsing(DecodingError?)
    case unknown

    var errorDescription: String? {
      switch self {
      case .network(let message):
        return message
      case .parsing(let error):
        return error?.localizedDescription ?? "unknown parsing error"
      case .unknown:
        return "unknown"
      }
    }
  }

  enum EndPoint {
    static let baseURL = "https://raw.githubusercontent.com/Swiftly-Systems/code-exercise-ios/master/backup"

    case specials

    var url: URL {
      switch self {
      case .specials:
        return URL(string: EndPoint.baseURL)!
      }
    }
  }

  func specials() -> AnyPublisher<Specials, Error> {
    URLSession.shared.dataTaskPublisher(for: EndPoint.specials.url)
      .map(\.data)
      .decode(type: Specials.self, decoder: decoder)
      .mapError { error in
        switch error {
        case is URLError:
          return Error.network(error.localizedDescription)
        case is DecodingError:
          return Error.parsing(error as? DecodingError)
        default:
          return Error.unknown
        }
      }
      .subscribe(on: serviceQueue)
      .eraseToAnyPublisher()
  }

  private let decoder = JSONDecoder()
  private let serviceQueue = DispatchQueue(label: "ManagersSpecialService", qos: .default, attributes: .concurrent)
}
