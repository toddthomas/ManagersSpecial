//
//  ChunkedByReduction.swift
//  ManagersSpecial
//
//  Created by Todd Thomas on 5/28/21.
//

import Algorithms
import Foundation

/// A collection that lazily chunks a base collection into subsequences using
/// the given reducing predicate.
///
/// - Note: This type is the result of
///
///     x.chunkedByReduction(into:_)
///
///   where `x` conforms to `LazyCollectionProtocol`.
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

extension ChunkedByReduction: LazyCollectionProtocol {
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

extension LazyCollectionProtocol {
  /// Lazily returns a collection of subsequences of this collection, chunked by
  /// the given reducing predicate.
  ///
  /// For example, to lazily chunk a list of integers into subsequences that sum to no more than 16:
  ///
  ///     let chunks = [16, 8, 8, 19, 12, 5].lazy.chunkedByReduction(into: 0) { sum, n in
  ///       sum += n
  ///       return sum <= 16
  ///     }
  ///
  ///     for chunk in chunks {
  ///       print(chunk)
  ///     }
  ///     // Prints:
  ///     // [16]
  ///     // [8, 8]
  ///     // [19]
  ///     // [12]
  ///     // [5]
  ///
  /// - Complexity: O(*n*), where *n* is the length of this collection.
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

extension Collection {
  /// Eagerly returns a collection of subsequences of this collection, chunked by
  /// the given reducing predicate.
  ///
  /// For example, to chunk a list of integers into subsequences that sum to no more than 16:
  ///
  ///     let chunks = [16, 8, 8, 19, 12, 5].chunkedByReduction(into: 0) { sum, n in
  ///       sum += n
  ///       return sum <= 16
  ///     }
  ///
  ///     for chunk in chunks {
  ///       print(chunk)
  ///     }
  ///     // Prints:
  ///     // [16]
  ///     // [8, 8]
  ///     // [19]
  ///     // [12]
  ///     // [5]
  ///
  /// - Complexity: O(*n*), where *n* is the length of this collection.
  public func chunkedByReduction<Accumulator>(
    into initialValue: Accumulator,
    _ predicate: @escaping (inout Accumulator, Element) throws -> Bool
  ) rethrows -> [SubSequence] {
    guard !isEmpty else { return [] }

    var result: [SubSequence] = []
    var accumulator = initialValue
    var start = startIndex
    var i = start

    while start < endIndex {
      while try i != endIndex && predicate(&accumulator, self[i]) {
        formIndex(after: &i)
      }

      if i == start { formIndex(after: &i) }

      result.append(self[start..<i])
      accumulator = initialValue
      start = i
    }

    return result
  }
}
