# frozen_string_literal: true

class Request
  attr_reader :n_rooms, :district, :hs_type

  def initialize(n_rooms, district, hs_type)
    @n_rooms = n_rooms
    @district = district
    @hs_type = hs_type
  end
end
