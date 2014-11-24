require 'fa'
require 'nfa'

module Pattern
  def bracket(outer_precedence)
    if precedence < outer_precedence
      '(' + to_s + ')'
    else
      to_s
    end
  end

  def inspect
    "/#{self}/"
  end

  def matches?(string)
    to_nfa_design.accepts?(string)
  end
end

class Empty
  include Pattern

  def to_s
    ''
  end

  def precedence
    3
  end

  def to_nfa_design
    start_state = Object.new
    accept_states = [start_state]
    rulebook = NFARulebook.new([])
    NFADesign.new(start_state, accept_states, rulebook)
  end
end

class Literal < Struct.new(:character)
  include Pattern

  def to_s
    character
  end

  def precedence
    3
  end

  def to_nfa_design
    start_state = Object.new
    accept_state = Object.new
    rule = FARule.new(start_state, character, accept_state)
    rulebook = NFARulebook.new([rule])
    NFADesign.new(start_state, [accept_state], rulebook)
  end
end

class Concatenate < Struct.new(:first, :second)
  include Pattern

  def to_s
    [first, second].map { |pattern| pattern.bracket(precedence) }.join
  end

  def precedence
    1
  end

  def to_nfa_design
    first_as_nfa = first.to_nfa_design
    second_as_nfa = second.to_nfa_design
    start_state = first_as_nfa.start_state
    accept_states = second_as_nfa.accept_states
    rules = first_as_nfa.rulebook.rules + second_as_nfa.rulebook.rules
    extra_rules = first_as_nfa.accept_states.map{ |state| FARule.new(state, nil, second_as_nfa.start_state) }
    rulebook = NFARulebook.new(rules + extra_rules)
    NFADesign.new(start_state, accept_states, rulebook)
  end
end

class Choose < Struct.new(:first, :second)
  include Pattern

  def to_s
    [first, second].map { |pattern| pattern.bracket(precedence) }.join('|')
  end

  def precedence
    0
  end

  def to_nfa_design
    first_as_nfa = first.to_nfa_design
    second_as_nfa = second.to_nfa_design
    start_state = Object.new
    accept_states = first_as_nfa.accept_states + second_as_nfa.accept_states
    rules = first_as_nfa.rulebook.rules + second_as_nfa.rulebook.rules
    extra_rules = [first_as_nfa, second_as_nfa].map { |nfa_design| FARule.new(start_state, nil, nfa_design.start_state) }
    rulebook = NFARulebook.new(rules + extra_rules)
    NFADesign.new(start_state, accept_states, rulebook)
  end
end

class Repeat < Struct.new(:pattern)
  include Pattern

  def to_s
    pattern.bracket(precedence) + '*'
  end

  def precedence
    2
  end

  def to_nfa_design
    pattern_as_nfa = pattern.to_nfa_design
    start_state = Object.new
    accept_states = pattern_as_nfa.accept_states + [start_state]
    rules = pattern_as_nfa.rulebook.rules
    extra_rules = pattern_as_nfa.accept_states.map { |accept_state| FARule.new(accept_state, nil, pattern_as_nfa.start_state) } +
                  [FARule.new(start_state, nil, pattern_as_nfa.start_state)]
    rulebook = NFARulebook.new(rules + extra_rules)
    NFADesign.new(start_state, accept_states, rulebook)
  end
end