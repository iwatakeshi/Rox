//
//  rox.function.ext.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/15/17.
//
//

import Foundation

extension RoxFunction: CustomStringConvertible{
  /// A textual representation of this instance.
  ///
  /// Instead of accessing this property directly, convert an instance of any
  /// type to a string by using the `String(describing:)` initializer. For
  /// example:
  ///
  ///     struct Point: CustomStringConvertible {
  ///         let x: Int, y: Int
  ///
  ///         var description: String {
  ///             return "(\(x), \(y))"
  ///         }
  ///     }
  ///
  ///     let p = Point(x: 21, y: 30)
  ///     let s = String(describing: p)
  ///     print(s)
  ///     // Prints "(21, 30)"
  ///
  /// The conversion of `p` to a string in the assignment to `s` uses the
  /// `Point` type's `description` property.
  var description: String {
    return "<func \(self.name == nil ? "" : self.name!)>"
  }

  
}
