class TriangleList
  @triangle = []
  def add_triangle(new_triangle)
    @triangle.push(new_triangle)
  end

  def each
    yield
  end
end
