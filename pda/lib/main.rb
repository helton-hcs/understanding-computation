require 'stack'
require 'pda'
require 'dpda'
require 'npda'

def print_separator(sep)
  puts sep * 100
end

def test_inputs(description, pda_design, inputs)
  puts "[#{description}]"
  puts pda_design
  inputs.each do |input|
    puts "Accepts \"#{input}\"? #{pda_design.accepts?(input)}"
    print_separator '-'
  end
end


def test_example1
  rulebook = DPDARulebook.new([PDARule.new(1, '(', 2, '$', %w(b $)),
                               PDARule.new(2, '(', 2, 'b', %w(b b)),
                               PDARule.new(2, ')', 2, 'b', []),
                               PDARule.new(2, nil, 1, '$', ['$'])
                              ])
  dpda_design = DPDADesign.new(1, '$', [1], rulebook)
  test_inputs('Recognize balanced parenthesized strings',
              dpda_design,
              %w{(((((((((())))))))))
                 ()(())((()))(()(()))
                 (()(()(()()(()()))())
                 (())
                 ())
              })
end

def test_example2
  rulebook = DPDARulebook.new([PDARule.new(1, 'a', 2, '$', %w(a $)),
                               PDARule.new(1, 'b', 2, '$', %w(b $)),
                               PDARule.new(2, 'a', 2, 'a', %w(a a)),
                               PDARule.new(2, 'b', 2, 'b', %w(b b)),
                               PDARule.new(2, 'a', 2, 'b', []),
                               PDARule.new(2, 'b', 2, 'a', []),
                               PDARule.new(2, nil, 1, '$', ['$'])
                              ])
  dpda_design = DPDADesign.new(1, '$', [1], rulebook)
  test_inputs('Recognize strings that contains the same count of two characters',
              dpda_design,
              %w{ababab
                 bbbaaaab
                 baa
              })
end

def test_example3
  rulebook = DPDARulebook.new([PDARule.new(1, 'a', 1, '$', %w(a $)),
                               PDARule.new(1, 'a', 1, 'a', %w(a a)),
                               PDARule.new(1, 'a', 1, 'b', %w(a b)),
                               PDARule.new(1, 'b', 1, '$', %w(b $)),
                               PDARule.new(1, 'b', 1, 'a', %w(b a)),
                               PDARule.new(1, 'b', 1, 'b', %w(b b)),
                               PDARule.new(1, 'm', 2, '$', ['$']),
                               PDARule.new(1, 'm', 2, 'a', ['a']),
                               PDARule.new(1, 'm', 2, 'b', ['b']),
                               PDARule.new(2, 'a', 2, 'a', []),
                               PDARule.new(2, 'b', 2, 'b', []),
                               PDARule.new(2, nil, 3, '$', ['$'])
                              ])
  dpda_design = DPDADesign.new(1, '$', [3], rulebook)
  test_inputs("Recognize palindrome strings made by 'a's and 'b's, with a 'm' at the middle of input",
              dpda_design,
              %w{abmab
                 babbamabbab
                 abmb
                 baambaa
              })
end

def test_example4
  rulebook = NPDARulebook.new([PDARule.new(1, 'a', 1, '$', ['a', '$']),
                               PDARule.new(1, 'a', 1, 'a', ['a', 'a']),
                               PDARule.new(1, 'a', 1, 'b', ['a', 'b']),
                               PDARule.new(1, 'b', 1, '$', ['b', '$']),
                               PDARule.new(1, 'b', 1, 'a', ['b', 'a']),
                               PDARule.new(1, 'b', 1, 'b', ['b', 'b']),
                               PDARule.new(1, nil, 2, '$', ['$']),
                               PDARule.new(1, nil, 2, 'a', ['a']),
                               PDARule.new(1, nil, 2, 'b', ['b']),
                               PDARule.new(2, 'a', 2, 'a', []),
                               PDARule.new(2, 'b', 2, 'b', []),
                               PDARule.new(2, nil, 3, '$', ['$'])
                              ])
  npda_design = NPDADesign.new(1, '$', [3], rulebook)
  test_inputs("Recognize palindrome strings made by 'a's and 'b's",
              npda_design,
              %w{abba
                 babbaabbab
                 abb
                 baabaa
              })
end

def main
  test_example1
  print_separator '='
  test_example2
  print_separator '='
  test_example3
  print_separator '='
  test_example4
end