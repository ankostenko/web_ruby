class FlatHolder
  def initialize(flats = [])
    @holder = flats
  end

  # add functionality
  def add(flat)
    @holder.push(flat)
  end

  def each 
    @holder.each { |flat| yield(flat) }
  end
end
