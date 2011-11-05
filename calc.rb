#!/usr/bin/env ruby

load "parser.rb"

# Just compute an expression per line
# may be called like this:
# $ echo "3 + 2" | ./calc.rb
# $ 5
# or like this (one expression per line
# in each file):
# $ ./calc.rb file{1..3}
# $ # print results
#

# Evaluate each line of the file
# Params:
# +f+:: the file to evaluate
def eval_file(f)
  parser = Parser.new
  f.each do |line|
    begin
      p Parser.new.eval line
    rescue
      $stderr.puts $!
    end
  end
end

if ARGV.size > 0
  ARGV.each do |filename|
    File.open(filename) do |f|
      eval_file f
    end
  end

else
  eval_file(ARGF)
end

