load "lexer.rb"

# The Parser class, evaluate an expression
# with the following grammar:
#
# expr = term {"+" + term}
#      | term {"-" + term}
#      | term
#
# term = factor {"*" + factor}
#      | factor {"/" + factor}
#      | factor
#
# factor = power ^ factor
#        | power
#
# power = "(" + expr + ")"
#       | ["-" | "+"] + power
#
class Parser
  @tokens = nil
  @@ops = {
          '+' => lambda { |a, b| a + b },
          '-' => lambda { |a, b| a - b },
          '*' => lambda { |a, b| a * b },
          '/' => lambda { |a, b| a / b },
          '^' => lambda { |a, b| a ** b },
  }

  # Evaluate the expression src, and return the result
  # Params:
  # +src+:: the expression to evaluate.
  def eval(src)
    @tokens = Lexer.new.lex src

    if @tokens.empty?
      raise 'Empty expression.'
    end

    # this is the "root" of our grammar
    v = expr

    # it remains no tokens so it perfect
    if @tokens.empty?
      v
    else
      @tokens.clear
      raise "Too much tokens..."
    end
  end

  private

  # remove the first token of @tokens and return it
  def consume_token
    @tokens.delete_at 0
  end

  # expr = term {"+" + term}
  #      | term {"-" + term}
  #      | term
  def expr
    lhs = term

    # left associative so while (no recursion)
    while ["+", "-"].include? @tokens.first
      lhs = @@ops[consume_token].call(lhs, term)
    end

    lhs
  end

  # term = factor {"*" + factor}
  #      | factor {"/" + factor}
  #      | factor
  def term
    lhs = factor

    # left associative
    while ["*", "/"].include? @tokens.first
      lhs = @@ops[consume_token].call(lhs, term)
    end

    lhs
  end

  # factor = power ^ factor
  #        | power
  def factor
    lhs = power

    # right associative
    if ["^"].include? @tokens.first
      @@ops[consume_token].call(lhs, term)
    else
      lhs
    end
  end

  # power = "(" + expr + ")"
  #       | ["-" | "+"] + power
  def power
    if @tokens.first == "("
      consume_token
      v = expr
      if consume_token == ")"
        v
      else
        raise "Parens doesn't match."
      end

    elsif ['+', '-'].include? @tokens.first
      @@ops[consume_token].call(0, power)

    else
      begin
        Integer consume_token
      rescue
        raise "Expected integer, found #{@tokens.first}."
      end
    end
  end
end

