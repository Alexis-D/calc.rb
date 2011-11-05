load "lexer.rb"

# TODO
# - more ops?
# - vars?
# - better error handling
# - degine a hash of ops/arity/fn?

# Grammar:
#
# expr = term {"+" term}
#      | term {"-" term}
#      | term
#
# term = factor {"*" factor}
#      | factor {"/" factor}
#      | factor
#
# factor = power ^ factor
#        | power
#
# power = "(" + expr + ")"
#       | ["-" | "+"] + power
#

class Parser
  def initialize
    @tokens = nil
  end

  def eval(src)
    @tokens = Lexer.new.lex src

    if @tokens.empty?
      raise 'Empty expression.'
    end

    v = expr

    if @tokens.empty?
      v
    else
      @tokens.clear
      raise "Too much tokens..."
    end
  end

  private

  def consume_token
    @tokens.delete_at 0
  end

  def expr
    lhs = term

    while ["+", "-"].include? @tokens.first
      op = @tokens.first
      @tokens = @tokens.drop 1
      rhs = term

      lhs = case op
            when "+"
              lhs + rhs
            when "-"
              lhs - rhs
            end
    end

    lhs
  end

  def term
    lhs = factor

    while ["*", "/"].include? @tokens.first
      op = @tokens.first
      @tokens = @tokens.drop 1
      rhs = factor
      lhs = case op
            when "*"
              lhs * rhs
            when "/"
              lhs / rhs
            end

    end

    lhs
  end

  def factor
    lhs = power

    if ["^"].include? @tokens.first
      op = @tokens.first
      @tokens = @tokens.drop 1
      rhs = factor

      case op
      when "^"
        lhs ** rhs
      end
    else
      lhs
    end
  end

  def power
    if @tokens.first == "("
      @tokens = @tokens.drop 1
      v = expr
      if @tokens.first == ")"
        @tokens = @tokens.drop 1
        v
      else
        raise "Parens doesn't match."
      end

    elsif ['+', '-'].include? @tokens.first
      op = @tokens.first
      @tokens = @tokens.drop 1

      case op
      when '+'
        power
      when '-'
        -power
      end

    else
      begin
        v = Integer @tokens.first
        @tokens = @tokens.drop 1
        v
      rescue
        raise "Expected integer, found #{@tokens.first}."
      end
    end
  end
end
