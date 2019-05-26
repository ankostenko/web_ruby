class Triangle
  def initialize(side_a, side_b, side_c)
    @side_a = side_a
    @side_b = side_b
    @side_c = side_c
  end

  def triangle?
    true
  end

  def area  
    return 0 unless triangle?
  end
end
