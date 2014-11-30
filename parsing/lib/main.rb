require 'simple_lexer'
require 'simple_parser'

def print_separator(sep)
  puts sep * 100
end

def test_inputs(inputs)
  parser = SimpleParser.new
  inputs.each do |input|
    puts "Input: #{input}"
    puts "Tokens: #{parser.tokenize(input).inspect}"
    puts "Accepts: #{parser.accepts?(input)}"
    print_separator '-'
  end
end

def main
  test_inputs(['y = x * 7',
               'while (x < 5) { x = x * 3 }',
               'while (x < 5 x = x * }'
              ])
end