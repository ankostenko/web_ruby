class Flat 
  attr_reader :square, :n_rooms, :address, :floor, :hs_type, :n_floors, :price

  def initialize(square, n_rooms, address, floor, 
                 hs_type, n_floors, price)
    @square = square
    @n_rooms = n_rooms
    @address = address
    @floor = floor
    @hs_type = hs_type
    @n_floors = n_floors
    @price = price
  end
end
