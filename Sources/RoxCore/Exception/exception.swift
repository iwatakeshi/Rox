public enum RoxSemanticException : Error {
  case error(Token, String)
}

public enum RoxRuntimeException : Error {
  case error(Token, String)
}

public enum RoxParserException: Error {
  case error(Token, String)
}

public enum RoxReturnException: Error {
  case `return`(Any?)
}

public enum RoxException {
    case RoxSemanticException(RoxSemanticException)
    case RoxRuntimeException(RoxRuntimeException)
    case RoxParserException(RoxParserException)
    case RoxReturnException(RoxReturnException)
}
