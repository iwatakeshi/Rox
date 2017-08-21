//
//  InterpreterTests.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/11/17.
//
//

import XCTest
import RoxCore

class InterpreterTests: XCTestCase {
    let lexer = Lexer()
    let parser = Parser()
    let interpreter = Interpreter()
  
  @discardableResult
  private func evaluate(_ source: String) -> Any? {
    do {
      let expression = parser.parse(lexer.scan(source), type: .Expression) as? Expression;
      let value = try interpreter.evaluate(expression!)
      if value is RoxNumber {
        return (value as! RoxNumber).value
      }
      return value
    } catch {
      return nil
    }
  }
  func testBinary() {
    // Numbers
    XCTAssertEqual(evaluate("1 + 1") as! Int, 2)
    XCTAssertEqual(evaluate("1 + 1.5") as! Double, 2.5)
    XCTAssertEqual(evaluate("1 - 1") as! Int, 0)
    XCTAssertEqual(evaluate("2.5 - 1") as! Double, 1.5)
    XCTAssertEqual(evaluate("1 * 1") as! Int, 1)
    XCTAssertEqual(evaluate("1.5 * 2") as! Double, 3.0)
    XCTAssertEqual(evaluate("1.5 / 1") as! Double, 1.5)
    XCTAssertNil(evaluate("1 / 0"))
    XCTAssertNil(evaluate("1.5 / 0"))

    // Conditions
    XCTAssertEqual(evaluate("true == true") as! Bool, true)
    XCTAssertEqual(evaluate("false == false") as! Bool, true)
    XCTAssertEqual(evaluate("true == false") as! Bool, false)
    XCTAssertEqual(evaluate("false == true") as! Bool, false)
    XCTAssertEqual(evaluate("false != false") as! Bool, false)
    XCTAssertEqual(evaluate("false != true") as! Bool, true)
    XCTAssertEqual(evaluate("true == 1 > 2") as! Bool, false)
    
    // Strings
    XCTAssertEqual(evaluate("\"Hello\" + \" world!\"") as! String, "Hello world!")
    XCTAssertNil(evaluate("\"Hello\" - \" world!\""))
    XCTAssertNil(evaluate("\"Hello\" * \" world!\""))
    XCTAssertNil(evaluate("\"Hello\" / \" world!\""))
      
  }
  
  func testParenthesized() {
    XCTAssertEqual(evaluate("(1 + (1))") as! Int, 2)
    XCTAssertEqual(evaluate("((1) + 1.5)") as! Double, 2.5)
    XCTAssertEqual(evaluate("(1 - 1)") as! Int, 0)
    XCTAssertEqual(evaluate("(2.5 - 1)") as! Double, 1.5)
    XCTAssertEqual(evaluate("(1 * 1)") as! Int, 1)
    XCTAssertEqual(evaluate("(1.5 * 2)") as! Double, 3.0)
    XCTAssertEqual(evaluate("(1.5 / 1)") as! Double, 1.5)
    XCTAssertNil(evaluate("(1 / 0)"))
    XCTAssertNil(evaluate("(1.5 / 0)"))
    
    // Strings
    XCTAssertEqual(evaluate("(\"Hello\" + \" world!\")") as! String, "Hello world!")
    XCTAssertNil(evaluate("(\"Hello\" - \" world!\")"))
    XCTAssertNil(evaluate("(\"Hello\" * \" world!\")"))
    XCTAssertNil(evaluate("(\"Hello\" / \" world!\")"))
  }
  
  func testLiteral() {
    // Numbers
    XCTAssertEqual(evaluate("1") as! Int, 1)
    XCTAssertEqual(evaluate("1.0") as! Double, 1.0)
    XCTAssertEqual(evaluate("\"Hello world!\"") as! String, "Hello world!")
    XCTAssertEqual(evaluate("true") as! Bool, true)
    XCTAssertEqual(evaluate("false") as! Bool, false)
  }
  
  func testUnary() {
    // Numbers
    XCTAssertEqual(evaluate("-1") as! Int, -1)
    XCTAssertEqual(evaluate("-1.0") as! Double, -(1.0))
    XCTAssertEqual(evaluate("!true") as! Bool, false)
    XCTAssertEqual(evaluate("!false") as! Bool, true)
  }
    
  func testPerformance() {
      // This is an example of a performance test case.
    self.measure {
        self.evaluate("1 + 1 * 2420 + 38348 / 2 + 2848 + (34843 + 2) + ( 2 * 2) + 33949238")
    }
  }
    
}
