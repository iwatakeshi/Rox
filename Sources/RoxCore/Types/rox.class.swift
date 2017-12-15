import Foundation

public class RoxClass: RoxCallableType, CustomStringConvertible {
  private(set) var name: String?
  private(set) var methods = Dictionary<String, RoxFunction>()
  internal(set) var call: ((_ interpreter: Interpreter, _ arguments: [Any?]) throws -> Any?)?
  internal(set) var arity: Int
  public var description: String { return name! }
  public init(_ name: String, _ methods: Dictionary<String, RoxFunction>) {
    self.name = name
    self.methods = methods
    self.arity = 0
    self.call = { (interpreter: Interpreter, arguments: [Any?]) throws -> Any? in
      let instance = RoxClassInstance(self)
      return instance;
    }
  }

  public func findMethod(_ instance: RoxClassInstance, _ name: String) -> RoxFunction? {
    if methods[name] != nil {
      return methods[name]
    }
    return nil
  }
}

public class RoxClassInstance: CustomStringConvertible {
  private(set) var `class`: RoxClass
  private(set) var fields = Dictionary<String, Any>()
  public var description: String { return "\(name) instance" }
  private(set) var name: String
  public init(_ `class`: RoxClass) {
    self.class = `class`;
    self.name = `class`.name!
  }

  public func get(_ name: Token) throws -> Any {
    if fields[name.lexeme] != nil {
      return fields[name.lexeme] as Any
    }

    let method = `class`.findMethod(self, name.lexeme)
    if method != nil {
      return method!
    }

    throw RoxRuntimeException.error(name, "Undefined property '\(name.lexeme)'")
  }

  public func set(_ name: Token, _ value: Any) {
    fields[name.lexeme] = value
  }
}