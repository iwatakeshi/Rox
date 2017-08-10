public class Rox {
  private static var errored = false
  public static func repl() {
    while true {
      print("> ", separator: " ", terminator: "")
      if let source = readLine() {
        Rox.run(source: source)
      }
    }
  }
  
  public static func run(source: String) {
    let scanner = Lexer(source)
    let parser = Parser(scanner.scan())
    let expression = parser.parse()
    
    // for token in tokens {
    //   print(token)
    // }
    print(ASTPrinter().print(expression: expression!))
    if errored { fatalError() }
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
    print("[ln \(location.line),col \(location.column)] error \(origin): \(message)")
    errored = true
  }
}
