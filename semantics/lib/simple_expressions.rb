require 'simple_core'

class Expression < Struct.new(:left, :right)
  def to_s
    "#{left} #{operator.to_s} #{right}"
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      self.class.new(left.reduce(environment), right)
    elsif right.reducible?
      self.class.new(left, right.reduce(environment))
    else
      value_class.new(left.value.send(operator, right.value))
    end
  end

  def evaluate(environment)
    value_class.new(left.evaluate(environment).value.send(operator, right.evaluate(environment).value))
  end

  def to_ruby
    "-> e { (#{left.to_ruby}).call(e).send(:#{operator}, (#{right.to_ruby}).call(e)) }"
  end
end

class ArithmeticExpression < Expression
  def value_class
    Number
  end
end

class Add < ArithmeticExpression
  def operator
    :+
  end
end

class Subtract < ArithmeticExpression
  def operator
    :-
  end
end

class Multiply < ArithmeticExpression
  def operator
    :*
  end
end

class Divide < ArithmeticExpression
  def operator
    :/
  end
end

class BooleanExpression < Expression
  def value_class
    Boolean
  end
end

class EqualThan < BooleanExpression
  def operator
    :==
  end
end

class LessThan < BooleanExpression
  def operator
    :<
  end
end

class GreaterThan < BooleanExpression
  def operator
    :>
  end
end

class LessOrEqualThan < BooleanExpression
  def operator
    :<=
  end
end

class GreaterOrEqualThan < BooleanExpression
  def operator
    :>=
  end
end