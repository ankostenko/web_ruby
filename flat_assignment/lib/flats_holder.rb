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

  def f_range(min, max)
    f_flats = []
    @holder.each do |flat| 
      if flat.price.to_i >= min.to_i && flat.price.to_i <= max.to_i
        f_flats.push(flat) 
      end
    end
    pp f_flats 
    f_flats
  end

  def each_with_index
    @holder.each_with_index { |flat, index| yield(flat, index) }
  end
end
