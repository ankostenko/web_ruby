# frozen_string_literal: true

class Address
  attr_reader :district

  def initialize(district, street, house)
    @district = district
    @street = street
    @house = house
  end

  def to_s
    "District: #{@district}, Street: #{@street}, House: #{@house}"
  end
end
