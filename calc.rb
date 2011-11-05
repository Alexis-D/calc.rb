#!/usr/bin/env ruby

load "parser.rb"

if ARGV.size > 0
  ARGV.each do |filename|
    parser = Parser.new
    File.open(filename) do |f|
      while src = f.gets
        begin
          p parser.eval src
        rescue
          p $!
        end
      end
    end
  end

else
  while src = STDIN.read
    begin
      p Parser.new.eval src
    rescue
      p $!
    end
  end
end

