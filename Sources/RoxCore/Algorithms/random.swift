import Foundation

#if os(Linux)
  func arc4random() -> Int {
    return random();
  }
#endif