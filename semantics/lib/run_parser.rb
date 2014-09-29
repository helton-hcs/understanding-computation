require 'treetop'

def launch
  Treetop.load(File.absolute_path('lib/simple'))
  simple_parser = SimpleParser.new
  parse_tree = simple_parser.parse(gets.chomp!)
  statement = parse_tree.to_ast
  puts statement.to_ruby
  puts statement.evaluate({}) #operational semantics, big-steps
end