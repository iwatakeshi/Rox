//
//  location.swift
//  rox
//
//  Created by Takeshi Iwana on 8/8/17.
//  Copyright © 2017 Takeshi Iwana. All rights reserved.
//

import Foundation

/// A structure representing the source code's location
public struct Location {
  /// Source position
  private(set) var position: Int = 0
  /// Source line number
  private(set) var line: Int = 1
  /// Source column number
  private(set) var column: Int = 1
  
  /**
   Initializes a new location
   */
  public init() {}
  
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
  }
    
}
