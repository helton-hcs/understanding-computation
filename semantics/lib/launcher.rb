require 'simple_expressions'
require 'simple_statements'
require 'machine'

def print_separator
  puts '=' * 100
end

def run
  expressions = [
      [Number.new(5),
       {}],

      [Boolean.new(false),
       {}],

      [Boolean.new(true),
       {}],

      [Variable.new(:x),
       { x: Number.new(7) }],


      [Number.new(23),
       {}
      ],

      [Variable.new(:x),
       { x: Number.new(23) }
      ],

      [Add.new(
           Variable.new(:x),
           Number.new(1)
       ),
       { x: Number.new(10) }],

      [LessThan.new(
           Add.new(
               Variable.new(:x),
               Number.new(1)
           ),
           Number.new(3)
       ),
       { x: Number.new(25) }],

      [LessThan.new(
           Add.new(
               Variable.new(:x),
               Number.new(2)
           ),
           Variable.new(:y)
       ),
       { x: Number.new(2),
         y: Number.new(5) }
      ],

      [Assign.new(
           :y,
           Add.new(
               Variable.new(:x),
               Number.new(1)
           )
       ),
       { x: Number.new(3) }],

      [If.new(
           Boolean.new(true),
           Assign.new(:x,
                      Number.new(1)
           ),
           Assign.new(:x,
                      Number.new(2)
           ),
       ),
       {}],

      [Sequence.new(
           Assign.new(:x,
                      Number.new(1)
           ),
           Assign.new(:y,
                      Add.new(
                          Variable.new(:x),
                          Number.new(10)
                      )
           )
       ),
       {}],

      [Sequence.new(
           Assign.new(
               :x,
               Add.new(
                   Number.new(1),
                   Number.new(1)
               )
           ),
           Assign.new(
               :y,
               Add.new(
                   Variable.new(:x),
                   Number.new(3)
               )
           )
       ),
       {}
      ],

      [While.new(
           LessThan.new(
               Variable.new(:x),
               Number.new(5)
           ),
           Assign.new(
               :x,
               Multiply.new(
                   Variable.new(:x),
                   Number.new(3)
               )
           )
       ),
       { x: Number.new(1)}
      ],

      [Add.new(
           Multiply.new(
               Number.new(1),
               Number.new(2)
           ),
           Multiply.new(
               Number.new(3),
               Number.new(4)
           )
       ),
       {}
      ],

      [Multiply.new(
           Number.new(1),
           Multiply.new(
               Add.new(
                   Number.new(2),
                   Number.new(3)
               ),
               Number.new(4)
           )
       ),
       {}
      ],

      [Divide.new(
           Subtract.new(
               Number.new(4),
               Add.new(
                   Number.new(5),
                   Number.new(7)
               )
           ),
           Multiply.new(
               Number.new(2),
               Number.new(11)
           )
       ),
       {}
      ],

      [LessThan.new(
           Number.new(4),
           Add.new(
               Number.new(2),
               Number.new(2)
           )
       ),
       {}
      ],

      [EqualThan.new(
           Number.new(4),
           Add.new(
               Number.new(1),
               Number.new(3)
           )
       ),
       {}
      ],

      [Add.new(
           Variable.new(:x),
           Variable.new(:y)
       ),
       { x: Number.new(3),
         y: Number.new(4) }
      ],

      [DoNothing.new,
       {}
      ],

      [Assign.new(
           :x,
           Add.new(
               Variable.new(:x),
               Number.new(1)
           )
       ),
       { x: Number.new(2) }
      ],

      [If.new(
           Variable.new(:x),
           Assign.new(
               :y,
               Number.new(1)
           ),
           Assign.new(
               :y,
               Number.new(2)
           )
       ),
       { x: Boolean.new(true) }
      ],

      [If.new(
           Variable.new(:x),
           Assign.new(
               :y,
               Number.new(1)
           ),
           DoNothing.new
       ),
       { x: Boolean.new(false) }
      ],

      [Sequence.new(
           Assign.new(
               :x,
               Add.new(
                   Number.new(1),
                   Number.new(1)
               )
           ),
           Assign.new(
               :y,
               Add.new(
                   Variable.new(:x),
                   Number.new(3)
               )
           )
       ),
       {}
      ],

      [While.new(
           LessThan.new(
               Variable.new(:x),
               Number.new(5)
           ),
           Assign.new(
               :x,
               Multiply.new(
                   Variable.new(:x),
                   Number.new(3)
               )
           )
       ),
       { x: Number.new(1) }
      ],

      [For.new(
           Assign.new(
               :i,
               Number.new(0)
           ),
           LessThan.new(
               Variable.new(:i),
               Number.new(10)
           ),
           Assign.new(
               :i,
               Add.new(
                   Variable.new(:i),
                   Number.new(1)
               )
           ),
           Assign.new(
               :x,
               Add.new(
                   Variable.new(:x),
                   Multiply.new(
                       Variable.new(:x),
                       Variable.new(:i)
                   )
               )
           ),
      ),
      { :x => Number.new(1) }
      ],

      [DoWhile.new(
           Sequence.new(
               Assign.new(
                   :x,
                   Add.new(
                       Variable.new(:x),
                       Variable.new(:i)
                   )
               ),
               Assign.new(
                   :i,
                   Add.new(
                       Variable.new(:i),
                       Number.new(1)
                   )
               )
           ),
           LessThan.new(
               Variable.new(:i),
               Number.new(10)
           )
      ),
      { :i => Number.new(0),
         :x => Number.new(0) }
      ]
  ]

  expressions.each do |pair|
    print_separator
    yield *pair
  end
end

def run_small_steps(expression, environment)
  puts '  <small_steps>'
  Machine.new(expression, environment, '    ').run
  puts '  </small_steps>'
end

def run_big_steps(expression, environment)
  puts '  <big_steps>'
  puts '    ' + expression.evaluate(environment).to_s
  puts '  </big_steps>'
end

def run_operational_semantics(expression, environment)
  puts '<operational_semantics>'
  run_small_steps(expression, environment)
  run_big_steps(expression, environment)
  puts '</operational_semantics>'
end

def eval_expression(expression, environment)
  eval(expression.to_ruby).call(environment)
end

def run_denotational_semantics(expression, environment)
  puts '<denotational_semantics>'
  environment.each do |key, value|
    environment[key] = eval_expression(value, {})
  end
  puts '  ' + expression.to_ruby
  puts '  ' + eval_expression(expression, environment).to_s
  puts '</denotational_semantics>'
end

def launch
  run do |expression, environment|
    puts '<expression>'
    puts '  ' + expression.to_s
    puts '</expression>'
    puts '<environment>'
    puts '  ' + environment.to_s
    puts '</environment>'
    run_operational_semantics(expression, environment)
    run_denotational_semantics(expression, environment)
  end
end
