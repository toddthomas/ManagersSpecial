//
//  ChunkedByReductionTests.swift
//  ManagersSpecialTests
//
//  Created by Todd Thomas on 6/1/21.
//

import XCTest

fileprivate struct Thing: Equatable {
  let width: Int
}

class EagerChunkedByReductionTests: XCTestCase {
  func testNonEmpty() throws {
    let things = [16, 8, 8, 5, 5, 5, 19, 4, 4, 4, 4, 4].map { Thing(width: $0) }
    let chunks = things.chunkedByReduction(into: 0) { sum, elem in
      sum += elem.width
      return sum <= 16
    }
    let expectedChunks: [[Thing]] = [
      [16].map { Thing(width: $0) },
      [8, 8].map { Thing(width: $0) },
      [5, 5, 5].map { Thing(width: $0) },
      [19].map { Thing(width: $0) },
      [4, 4, 4, 4].map { Thing(width: $0) },
      [4].map { Thing(width: $0) }
    ]

    XCTAssertEqual(chunks.map { Array($0) }, expectedChunks)
  }

  func testEmpty() throws {
    let things: [Thing] = []
    let chunks = things.chunkedByReduction(into: 0) { sum, elem in
      sum += elem.width
      return sum <= 16
    }

    XCTAssertEqual(chunks, [])
  }
}

class LazyChunkedByReductionTests: XCTestCase {
  func testNonEmpty() throws {
    let things = [16, 8, 8, 5, 5, 5, 19, 4, 4, 4, 4, 4].map { Thing(width: $0) }
    let chunks = things.lazy.chunkedByReduction(into: 0) { sum, elem in
      sum += elem.width
      return sum <= 16
    }
    let expectedChunks: [[Thing]] = [
      [16].map { Thing(width: $0) },
      [8, 8].map { Thing(width: $0) },
      [5, 5, 5].map { Thing(width: $0) },
      [19].map { Thing(width: $0) },
      [4, 4, 4, 4].map { Thing(width: $0) },
      [4].map { Thing(width: $0) }
    ]

    XCTAssertEqual(chunks.map { Array($0) }, expectedChunks)
  }

  func testEmpty() throws {
    let things: [Thing] = []
    let chunks = things.lazy.chunkedByReduction(into: 0) { sum, elem in
      sum += elem.width
      return sum <= 16
    }

    XCTAssertEqual(chunks.map { Array($0) }, [])
  }
}
