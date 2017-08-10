//
//  location.swift
//  rox
//
//  Created by Takeshi Iwana on 8/8/17.
//  Copyright © 2017 Takeshi Iwana. All rights reserved.
//

import Foundation

public struct Location {
  private(set) var position: Int = 0
  private(set) var line: Int = 1
  private(set) var column: Int = 1
  
  public init(position: Int, line: Int, column: Int) {
    self.position = position
    self.line = line
    self.column = column
  }
    
}
