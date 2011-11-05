#!/usr/bin/env ruby

require "test/unit"

load "./lexer.rb"
load "./parser.rb"

class TestLexer < Test::Unit::TestCase
  def test_lex_ok
    l = Lexer.new
    assert_equal [], l.lex("")
    assert_equal [], l.lex(" \t\n")
    assert_equal ["3"], l.lex("3")
    assert_equal ["3", "+", "2"], l.lex("3 + 2")
    assert_equal ["(", "3", "+", "2", ")"], l.lex("(3 + 2)")
    assert_equal ["(", "3", "^", "1", "+", "2", ")"], l.lex("(3^1 + 2)")
  end

  def test_lex_fail
    l = Lexer.new
    assert_raise(RuntimeError) { l.lex("~") }
    assert_raise(RuntimeError) { l.lex(" __hello__ ") }
  end
end

class TestParser < Test::Unit::TestCase
  def test_eval_ok
    p = Parser.new
    assert_equal 0, p.eval("0")
    assert_equal 42, p.eval(" 42 ")
    assert_equal 1, p.eval("--1")
    assert_equal 42, p.eval("6*7+3-(2--1)^0-(((2)))")
    assert_equal 0, p.eval("2 - 1 - 1")
    assert_equal 0, p.eval("(2 - 1) - 1")
    assert_equal 0, p.eval("((2 - 1) - 1)")
    assert_equal 0, p.eval("(((2 - 1) - 1))")
    assert_equal 2 ** (3 ** 4), p.eval("2 ^ 3 ^ 4")
  end

  def test_eval_fail
    p = Parser.new
    assert_raise(RuntimeError) { p.eval('') }
    assert_raise(RuntimeError) { p.eval('()') }
    assert_raise(RuntimeError) { p.eval('(3') }
    assert_raise(RuntimeError) { p.eval(')3') }
    assert_raise(RuntimeError) { p.eval('3 ++ ') }
  end
end

