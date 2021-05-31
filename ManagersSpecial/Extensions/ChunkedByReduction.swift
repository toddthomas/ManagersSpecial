//
//  ChunkedByReduction.swift
//  ManagersSpecial
//
//  Created by Todd Thomas on 5/28/21.
//

import Foundation

public struct ChunkedByReduction<Accumulator, Base: Collection> {
  internal let base: Base
  internal let initialValue: Accumulator
  internal let predicate: (inout Accumulator, Base.Element) -> Bool

  internal var _startIndex: Index

  internal init(
    base: Base,
    initialValue: Accumulator,
    predicate: @escaping (inout Accumulator, Base.Element) -> Bool
  ) {
    self.base = base
    self.initialValue = initialValue
    self.predicate = predicate

    self._startIndex = Index(baseRange: base.startIndex..<base.startIndex)
    if !base.isEmpty {
      self._startIndex = indexForSubsequence(startingAt: base.startIndex)
    }
  }
}

extension ChunkedByReduction: Collection {
  public struct Index: Comparable {
    internal let baseRange: Range<Base.Index>

    internal init(baseRange: Range<Base.Index>) {
      self.baseRange = baseRange
    }

    public static func < (lhs: Index, rhs: Index) -> Bool {
      lhs.baseRange.upperBound <= rhs.baseRange.lowerBound
        && lhs.baseRange.upperBound < rhs.baseRange.upperBound
    }

    public static func == (lhs: Index, rhs: Index) -> Bool {
      lhs.baseRange == rhs.baseRange
    }
  }

  internal func indexForSubsequence(
    startingAt lowerBound: Base.Index
  ) -> Index {
    guard lowerBound < base.endIndex else { return endIndex }

    var accumulator = initialValue
    var i = lowerBound

    while i != base.endIndex && predicate(&accumulator, base[i]) {
      base.formIndex(after: &i)
    }

    if i == lowerBound { base.formIndex(after: &i) }

    return Index(baseRange: lowerBound..<i)
  }

  public var startIndex: Index {
    _startIndex
  }

  public var endIndex: Index {
    Index(
      baseRange: base.endIndex..<base.endIndex
    )
  }

  public func index(after i: Index) -> Index {
    precondition(i != endIndex, "Can't advance past endIndex")

    return indexForSubsequence(startingAt: i.baseRange.upperBound)
  }

  public subscript(position: Index) -> Base.SubSequence {
    precondition(position != endIndex, "Can't subscript using endIndex")
    return base[position.baseRange]
  }
}

extension Collection {
  public func chunkedByReduction<Accumulator>(
    into initialValue: Accumulator,
    _ predicate: @escaping (inout Accumulator, Element) -> Bool
  ) -> ChunkedByReduction<Accumulator, Self> {
    ChunkedByReduction(
      base: self,
      initialValue: initialValue,
      predicate: predicate
    )
  }
}
