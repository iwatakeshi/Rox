//
//  location.ext.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/9/17.
//
//

import Foundation

extension Location: Equatable {
  public static func ==(left: Location, right: Location) -> Bool{
    return left.column == right.column && left.line == right.line && left.position == right.position
  }
}
