class Machine < Struct.new(:statement, :environment, :indentation)
  def step
    self.statement, env = statement.reduce(environment)
    self.environment = env if not env.nil?
  end

  def run
    while statement.reducible?
      puts indentation + "#{statement}, #{environment}"
      step
    end
    puts indentation + "#{statement}, #{environment}"
  end
end