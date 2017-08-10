public class Expression {
  class Binary: Expression {
    private(set) var left: Expression
    private(set) var right: Expression
    private(set) var token: Token
    public init(left: Expression, token: Token, right: Expression) {
      self.left = left
      self.token = token
      self.right = right
    }
  }
}
