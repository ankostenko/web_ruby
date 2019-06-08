# frozen_string_literal: true

# redundant comment
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

  def find(address)
    @holder.each_with_index do |flat, index|
      # string comparison
      return index if flat.address.to_s == address.to_s
    end
  end

  def empty?
    @holder.empty?
  end

  def each
    @holder.each { |flat| yield(flat) }
  end

  def f_range(min, max)
    f_flats = []
    @holder.each do |flat|
      f_flats.push(flat) if flat.price.to_i >= min.to_i && flat.price.to_i <= max.to_i
    end
    f_flats
  end

  def group_and_sort(district)
    g_flats = []
    @holder.each do |flat|
      g_flats.push(flat) if flat.address.district == district
    end

    g_flats.sort! { |a, b| a.square.to_i - b.square.to_i }
  end

  def group(n_rooms, dist, hs_type)
    fully_matched_flats = []
    part_matched_flats = []
    @holder.each do |flat|
      if dist == flat.address.district && hs_type == flat.hs_type
        if n_rooms.to_i == flat.n_rooms.to_i
          fully_matched_flats.push(flat)
        elsif (n_rooms.to_i - flat.n_rooms.to_i).abs <= 1
          part_matched_flats.push(flat)
        end
      end
    end

    [fully_matched_flats, part_matched_flats]
  end

  def each_with_index
    @holder.each_with_index { |flat, index| yield(flat, index) }
  end
end
