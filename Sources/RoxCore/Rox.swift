import Foundation

public class Rox {
  private static var errored = false
  private static var runtimeErrored = false
  private static var interpreter = Interpreter()
  
  public static func repl() {
    while true {
      print("> ", separator: " ", terminator: "")
      if let source = readLine() {
        do {
          try Rox.run(source)
        } catch RoxRuntimeException.error(let token, let message) {
          error(.RoxRuntimeException(.error(token, message)))
        } catch {
          
        }
        errored = false
      }
    }
  }
  /**
   Starts a Rox process
   
   - Parameter file: The path to the file
   */
  public static func run(_ file: URL) {
    if errored { return }
    if runtimeErrored { return }
    do {
      let source = try String(contentsOf: file)
      try run(source)
    } catch {
      return
    }
  }
  
  /**
   Starts a Rox process
   - Parameter source: A string containing the source code
  */
  public static func run(_ source: String) throws {
    let scanner = Lexer(source)
    let parser = Parser(scanner.scan())
    let statements = parser.parse()
    if errored { return }
    interpreter.interpret(statements)
    
  }
  
  public static func error(_ type: RoxException) {
    
    switch type {
    case .RoxRuntimeException(.error(let token, let message)):
      print("[ln \(token.location.line), col \(token.location.column)] error : \(message)")
      runtimeErrored = true
      break
    case .RoxParserException(.error(let token, let message)):
      error(token, message)
      errored = true
      break
    }
  }
  
  public static func error(_ location: Location, _ message: String) {
    report(location, "", message)
  }
  
  public static func error(_ token: Token, _ message: String) {
    if token.type == .EOF {
      report(token.location, "at end", message)
    } else  {
      report(token.location, "at '\(token.lexeme)'", message)
    }
  }
  
  public static func report(_ location: Location, _ origin: String, _ message: String) {
    print("[ln \(location.line), col \(location.column)] error \(origin): \(message)")
    errored = true
  }
}
