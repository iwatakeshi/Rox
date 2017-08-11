public enum RoxRuntimeException : Error {
  case error(Token, String)
}

public enum RoxParserException: Error {
  case error(Token, String)
}


public enum RoxException {
    case RoxRuntimeException(RoxRuntimeException)
    case RoxParserException(RoxParserException)
}
