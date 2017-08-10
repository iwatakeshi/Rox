//
//  main.swift
//  rox
//
//  Created by Takeshi Iwana on 8/8/17.
//  Copyright © 2017 Takeshi Iwana. All rights reserved.
//

import Foundation
import Core

private func read(path: String) -> String {
  let file = URL(fileURLWithPath: path)
  do {
    let source = try String(contentsOf: file)
    return source
  } catch {
    return ""
  }
}


let arguments = CommandLine.arguments

if arguments.count > 2 {
  print("Usage: rox [script]")
} else if arguments.count == 2 {
  Rox.run(source: read(path: arguments[0]))
} else {
  Rox.repl()
}
