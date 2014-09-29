require 'fa'
require 'dfa'
require 'nfa'

def test_dfa(start_state, accept_states, rulebook, inputs)
  dfa_design = DFADesign.new(start_state, accept_states, rulebook)
  puts 'DFA = ' + dfa_design.inspect
  inputs.each do |string|
    puts "Accepts \"#{string}\"? #{dfa_design.accepts?(string)}"
  end
end

def test_nfa(start_state, accept_states, rulebook, inputs)
  nfa_design = NFADesign.new(start_state, accept_states, rulebook)
  puts 'NFA = ' + nfa_design.inspect
  inputs.each do |string|
    puts "Accepts \"#{string}\"? #{nfa_design.accepts?(string)}"
  end

end

def test_dfas
  puts '=' * 20
  puts "Testing DFA's..."
  puts '=' * 20

  #accept strings that contain the sequence 'ab'
  test_dfa(1, [3],
           DFARulebook.new(
               [FARule.new(1, 'a', 2), FARule.new(1, 'b', 1),
                FARule.new(2, 'a', 2), FARule.new(2, 'b', 3),
                FARule.new(3, 'a', 3), FARule.new(3, 'b', 3)
               ]
           ),
           %w(a baa baba baaab)
  )
end

def test_nfas
  puts '=' * 20
  puts "Testing NFA's..."
  puts '=' * 20

  #accept string where the third-from-last character is 'b'
  test_nfa(1, [4],
           NFARulebook.new(
               [FARule.new(1, 'a', 1), FARule.new(1, 'b', 1), FARule.new(1, 'b', 2),
                FARule.new(2, 'a', 3), FARule.new(2, 'b', 3),
                FARule.new(3, 'a', 4), FARule.new(3, 'b', 4)
               ]
           ),
           %w(bab bbbbb bbabb)
  )

  #accepts strings whose length is a multiple of 2 or 3
  test_nfa(1, [2, 4],
           NFARulebook.new(
               [FARule.new(1, nil, 2), FARule.new(1, nil, 4),
                FARule.new(2, 'a', 3),
                FARule.new(3, 'a', 2),
                FARule.new(4, 'a', 5),
                FARule.new(5, 'a', 6),
                FARule.new(6, 'a', 4)
               ]
           ),
           %w(a aa aaa aaaa aaaaa aaaaaa)
  )
end

def main
  test_dfas
  test_nfas
end