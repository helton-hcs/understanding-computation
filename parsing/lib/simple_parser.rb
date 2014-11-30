# SIMPLE GRAMMAR

# <statement>    ::= <while> | <assign>
# <while>        ::= 'w' '(' <expression> ')' '{' <statement> '}'
# <assign>       ::= 'v' '=' <expression>
# <expression>   ::= <less-than>
# <less-than>    ::= <multiply> '<' <less-than> | <multiply>
# <multiply>     ::= <term> '*' <multiply> | <term>
# <term>         ::= 'n' | 'v'

require 'pda'
require 'npda'
require 'simple_lexer'

class SimpleParser
  def initialize
    start_rule = PDARule.new(1, nil, 2, '$', %w(S $))

    symbol_rules = [
        # <statement> ::= <while> | <assign>
        PDARule.new(2, nil, 2, 'S', ['W']),
        PDARule.new(2, nil, 2, 'S', ['A']),

        # <while> ::= 'w' '(' <expression> ')' '{' <statement> '}'
        PDARule.new(2, nil, 2, 'W', %w|w ( E ) { S }|),

        # <assign> ::= 'v' '=' <expression>
        PDARule.new(2, nil, 2, 'A', %w|v = E|),

        # <expression> ::= <less-than>
        PDARule.new(2, nil, 2, 'E', ['L']),

        # <less-than> ::= <multiply> '<' <less-than> | <multiply>
        PDARule.new(2, nil, 2, 'L', %w|M < L|),
        PDARule.new(2, nil, 2, 'L', ['M']),

        # <multiply> ::= <term> '*' <multiply> | <term>
        PDARule.new(2, nil, 2, 'M', %w|T * M|),
        PDARule.new(2, nil, 2, 'M', ['T']),

        # <term> ::= 'n' | 'v'
        PDARule.new(2, nil, 2, 'T', ['n']),
        PDARule.new(2, nil, 2, 'T', ['v'])
    ]

    token_rules = SimpleLexicalAnalyzer::GRAMMAR.map do |rule|
      PDARule.new(2, rule[:token], 2, rule[:token], [])
    end

    stop_rule = PDARule.new(2, nil, 3, '$', ['$'])

    rulebook = NPDARulebook.new([start_rule, stop_rule] + symbol_rules + token_rules)

    @npda_design = NPDADesign.new(1, '$', [3], rulebook)
  end

  def tokenize(string)
    SimpleLexicalAnalyzer.new(string).analyze.join
  end

  def accepts?(string)
    @npda_design.accepts?(tokenize(string))
  end
end