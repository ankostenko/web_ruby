class FlatHolder
  def initialize(flats = [])
    @holder = flats
  end

  # add functionality
  def add(flat)
    @holder.push(flat)
  end

  def remove(index)
    @holder.delete_at(index.to_i)
  end

  def each 
    @holder.each { |flat| yield(flat) }
  end

  def each_with_index
    @holder.each_with_index { |flat, index| yield(flat, index) }
  end
end
