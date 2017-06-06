class Employee
  attr_reader :name, :title, :salary, :boss

  def initialize(name, title, salary, boss = nil)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
    update_manager
  end

  def update_manager
    @boss.employees << self unless @boss.nil?
  end

  def bonus(multiplier)
    bonus = @salary * multiplier
  end
end

class Manager < Employee
  attr_accessor :employees

  def initialize(name, title, salary, boss = nil, employees = [])
    super(name, title, salary, boss)
    @employees = employees
  end

  def bonus(multiplier)
    get_salary_of_subordinates * multiplier
  end

  def get_salary_of_subordinates
    return 0 if employees.empty? || !self.is_a?(Manager)

    total_sal = 0
    @employees.each do |emp|
      total_sal += emp.salary
      total_sal += emp.get_salary_of_subordinates if emp.is_a?(Manager)
    end
    total_sal
  end

end

if __FILE__ == $PROGRAM_NAME
  ned = Manager.new("Ned", "Founder", 1000000)
  darren = Manager.new("darren", "manager", 78000, ned)
  shawna = Employee.new("shawna", "TA", 12000, darren)
  david = Employee.new("david", "TA", 10000, darren)

p ned.bonus(5) # => 500_000
p darren.bonus(4) # => 88_000
p david.bonus(3) # => 30_000
end
