# frozen_string_literal: true

# Redundant comment
module Statistics
  # get has of all available districts
  def self.extr_dist(flats, reqs)
    districts = {}
    # create hash of all districts
    flats.each do |flat|
      dist = flat.address.district
      districts[dist] = nil unless districts.key?(dist)
    end

    reqs.each do |req|
      dist = req.district
      districts[dist] = nil unless districts.key?(dist)
    end
    districts
  end

  def self.flats_info(flats, dist_info, key)
    flats.each do |flat|
      next unless key == flat.address.district

      dist_info[:a_flats] += 1
      dist_info[:m_sqr] += flat.square.to_i
      dist_info[:m_prc] += flat.price.to_i
    end
    dist_info
  end

  def self.coverage_eval(dist_info, requests, key, flats)
    number_matched_flats = 0
    requests.each do |req|
      next unless key == req.district

      dist_info[:a_reqs] += 1
      matched_flats = flats.group(req.n_rooms, req.district, req.hs_type)
      number_matched_flats += matched_flats[0].length
    end
    dist_info[:cov] = (number_matched_flats.to_f / dist_info[:a_reqs]) unless dist_info[:a_reqs].zero?
    dist_info
  end

  def self.mean_values(dist_info)
    unless dist_info[:a_flats].zero?
      dist_info[:m_sqr] /= dist_info[:a_flats]
      dist_info[:m_prc] /= dist_info[:a_flats]
    end
    dist_info
  end

  def self.district_info(dist, flats, requests)
    # amount of flats, mean square, mean price, amount of requests, coverage
    dist_info = { a_flats: 0, m_sqr: 0, m_prc: 0, a_reqs: 0, cov: 0 }
    dist_info = flats_info(flats, dist_info, dist)
    dist_info = coverage_eval(dist_info, requests, dist, flats)
    dist_info = mean_values(dist_info)
    dist_info
  end
end
