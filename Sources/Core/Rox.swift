public class Rox {
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
    let tokens = scanner.scan()
    for token in tokens {
      print(token)
    }
  }
}
