require 'regex'

def print_separator(sep)
  puts sep * 30
end

def test_pattern(pattern, inputs)
  inputs.each { |input| puts "#{pattern.inspect} matches \"#{input}\"? #{pattern.matches?(input).to_s}" }
  print_separator '-'
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
end