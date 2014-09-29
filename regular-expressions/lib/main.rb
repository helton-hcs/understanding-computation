require 'regex'

def main
  pattern = Repeat.new(
      Choose.new(
          Concatenate.new(
              Literal.new('a'),
              Literal.new('b')
          ),
          Literal.new('a')
      )
  )
  puts pattern.inspect
end