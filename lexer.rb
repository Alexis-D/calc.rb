class Lexer
  # Lex the string src.
  # Tokens are:
  # - +
  # - -
  # - *
  # - /
  # - (
  # - )
  # - \d+
  #
  # Spaces are ignored
  # Params:
  # +src+:: the string to lex
  def lex(src)
    if src =~ /[^^\d\s+*-\/()]/
      raise "Invalid token in '#{$~.to_s}'."
    end

    src.scan /\d+|[+*-\/^()]/
  end
end

