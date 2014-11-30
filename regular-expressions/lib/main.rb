require 'regex'
require 'treetop'

def print_separator(sep)
  puts sep * 30
end

def test_pattern(pattern, inputs)
  inputs.each { |input| puts "#{pattern.inspect} matches \"#{input}\"? #{pattern.matches?(input).to_s}" }
  print_separator '-'
end

def test_regex(str_pattern, inputs)
  parse_tree = PatternParser.new.parse(str_pattern)
  pattern = parse_tree.to_ast
  inputs.each { |input| puts "#{pattern.inspect} matches \"#{input}\"? #{pattern.matches?(input).to_s}" }
  print_separator '-'
end

def test_parsed_regexes
  Treetop.load(File.join(File.dirname(__FILE__), 'pattern'))
  test_regex('(a(|b))*', %w{abaab abba})
  test_regex('aa*b', %w{a ab aab aaaaaaab abc})
end

def main
  test_pattern(Concatenate.new(
                   Literal.new('a'),
                   Literal.new('b')
               ),
               %w{a b ab abc}
  )
  test_pattern(Concatenate.new(
                   Literal.new('a'),
                   Concatenate.new(
                       Literal.new('b'),
                       Literal.new('c')
                   )
               ),
               %w{a b ab abc}
  )
  test_pattern(Choose.new(
                   Literal.new('a'),
                   Literal.new('b')
               ),
               %w{a b c}
  )
  test_pattern(Repeat.new(
                   Choose.new(
                       Concatenate.new(
                           Literal.new('a'),
                           Literal.new('b')
                       ),
                       Literal.new('a')
                   )
               ),
               %w{a ab b abab aaaababab}
  )
  test_pattern(Repeat.new(
                   Concatenate.new(
                       Literal.new('a'),
                       Choose.new(
                           Empty.new,
                           Literal.new('b')
                       )
                   )
               ),
               %w{a ab aba abab abaab abba}
  )
  test_parsed_regexes
end