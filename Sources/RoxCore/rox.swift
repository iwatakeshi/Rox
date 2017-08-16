import Foundation

public class Rox {
  private static var errored = false
  private static var runtimeErrored = false
  private static var interpreter = Interpreter()
  private static var about: String {
    get {
      let date = Date(), year = Calendar.current.component(.year, from: date)
      let project = "Rox", version = "0.0.0", license = "MIT License"
      let copyright = "Copyright © 2015 - \(year) Takeshi Iwana"
      
      var str = ""
      str.append(project)
      str.append("\n")
      str.append(version)
      str.append("\n")
      str.append(license)
      str.append("\n")
      str.append(copyright)
      return str
    }
  }
  private struct Stack<Element> {
    private var items = [Element]()
    public var count: Int { get { return items.count } }
    public var empty: Bool { get { return items.count == 0 } }
    mutating func push(_ item: Element) {
      items.append(item)
    }
    @discardableResult
    mutating func pop() -> Element {
      return items.removeLast()
    }
  }
  
  public static func repl() {
    print(about)
    while true {
      if var source = readLine() {
        print("> ", separator: " ", terminator: "")
        if (source == ":exit") {
          break
        }
        if source == ":clear" {
          print(String(repeating: "\n", count: 1000))
          continue
        }
        source = process(source)
        do {
          try Rox.run(source)
        } catch RoxRuntimeException.error(let token, let message) {
          error(.RoxRuntimeException(.error(token, message)))
        } catch {}
        
        errored = false
      }
    }
  }
  
  private static func process(_ source: String) -> String {
    var result = source
    var depth = 1
    while true {
      if isBalanced(result) { break }
      let spacer = String(repeating: "..", count: depth)
      print("\(spacer) ", separator: " ", terminator: "")
      if let line = readLine() {
        result.append(line)
        if line.count > 0 {
          let left = ["{", "(", "["], right = ["}", ")", "]"]
          if left.contains(line.last) {
            depth = depth * 2
          }
          if right.contains(line.last) {
            if !isBalanced(result) {
              depth = depth / 2
            }
          }
          
        }
      }
    }
    return result
  }
  
  private static func isBalanced(_ line: String) -> Bool {
    var balanced: Bool = true
    var stack = Stack<Character>()
    for (_, s) in line.toArray().enumerated() {
      switch s {
      case "{": fallthrough
      case "(": fallthrough
      case "[": stack.push(s); break
      case "}": fallthrough
      case ")": fallthrough
      case "]":
        if stack.empty { balanced = false }
        else  { stack.pop() }
        break
      default: break
      }
    }
    return stack.empty && balanced
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
    let syntax = parser.parseRepl()
    if errored { return }
    
    if syntax is [Statement] {
      interpreter.interpret(syntax as! [Statement])
    } else if syntax is Expression {
      let result = interpreter.interpret(syntax as! Expression)
      if (result != nil) {
        print((result as Any?)!)
      }
      
    }
    
  }
  
  public static func error(_ type: RoxException) {
    
    switch type {
    case .RoxRuntimeException(.error(let token, let message)):
      print("error (\(token.location.line),\(token.location.column)): \(message)")
      runtimeErrored = true
      break
    case .RoxParserException(.error(let token, let message)):
      error(token, message)
      errored = true
      break
    default: break
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
    print("error (\(location.line),\(location.column)): \(origin): \(message)")
    errored = true
  }
}
