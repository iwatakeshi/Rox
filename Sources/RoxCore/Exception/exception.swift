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
    case RoxRuntimeException(RoxRuntimeException)
    case RoxParserException(RoxParserException)
    case RoxReturnException(RoxReturnException)
}
