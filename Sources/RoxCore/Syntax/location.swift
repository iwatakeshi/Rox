//
//  location.swift
//  rox
//
//  Created by Takeshi Iwana on 8/8/17.
//  Copyright © 2017 Takeshi Iwana. All rights reserved.
//

import Foundation

/// A structure representing the source code's location.
public class Location {
  /// Source position
  private(set) var position: Int = 0
  /// Source line number
  private(set) var line: Int = 1
  /// Source column number
  private(set) var column: Int = 1
  private(set) var start: (position: Int, line: Int, column: Int)
  private(set) var end: (position: Int, line: Int, column: Int)
  /**
   Initializes a new location
   */
  public init() {
    start = (position, line, column)
    end = start
  }
  
  /**
   Initializes a new location
   
   - Parameters:
   - position: The scanner current position
   - line: The scanner's current line number
   - column: The scanner's current column number
   
   - Returns: An instance of Location
   */
  public init(_ position: Int, _ line: Int, _ column: Int) {
    self.position = position
    self.line = line
    self.column = column
    start = (position, line, column)
    end = start
  }
  
  public init(_ start: (position: Int, line: Int, column: Int), _ end: (position: Int, line: Int, column: Int)) {
    self.position = start.position
    self.line = start.line
    self.column = start.column
    self.start = (position, line, column)
    self.end = (position, line, column)
  }
  
  public static func mark(_ start: Location, _ end: Location) -> Location {
    return Location((start.position, start.line, start.column), (end.position, end.line, end.column))
  }
}
