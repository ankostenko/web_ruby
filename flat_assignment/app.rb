# frozen_string_literal: true

require 'pstore'
require_relative 'lib/flats_holder'
require_relative 'lib/flat'
require_relative 'lib/request'
require_relative 'lib/request_holder'
require_relative 'lib/address'

storage = PStore.new('data/database.pstore')

storage.transaction(true) do
  @flats = storage[:flats]
  @requests = storage[:requests]
  @flats ||= FlatHolder.new
  @requests ||= RequestHolder.new
end

at_exit do
  storage.transaction do
    storage[:flats] = @flats
    storage[:requests] = @requests
  end
end

require 'sinatra'

configure do
  set :flats, @flats
  set :requests, @requests
end

get '/' do
  @flats = settings.flats
  @requests = settings.requests
  erb :show_flats
end

get '/main' do
  @flats = settings.flats
  @requests = settings.requests
  erb :show_flats
end

get '/add_flat' do
  erb :add_flat
end

post '/add_flat' do
  address = Address.new(params['dist'], params['street'], params['n_house'])
  flat = Flat.new(params['square'], params['n_rooms'], address, params['floor'],
                  params['hs_type'], params['n_floors'], params['price'])
  settings.flats.add(flat)
  redirect('/main')
end

get '/delete_flat' do
end

post '/delete_flat' do
  settings.flats.remove(params['index'])
  redirect('/main')
end

get '/show_flats' do
  @flats = settings.flats
  erb :show_flats
end

post '/show_flats_r' do
  @flats = settings.flats.f_range(params['range-min'], params['range-max'])
  erb :show_flats
end

post '/show_flats_g' do
  @flats = settings.flats.group_and_sort(params['dist'])
  erb :show_flats
end

get '/show_requests' do
  @requests = settings.requests.sort! { |a, b| a.n_rooms.to_i - b.n_rooms.to_i }
  erb :show_requests
end

get '/delete_request' do
end

post '/delete_request' do
  settings.requests.remove(params['index'])
  redirect('/show_requests')
end

get '/add_request' do
  erb :add_request
end

post '/add_request' do
  request = Request.new(params['n_rooms'], params['district'], params['hs_type'])
  settings.requests.add(request)
  redirect('/show_requests')
end

post '/find_flats' do
  @index = params['index']
  @n_rooms = params['n_rooms']
  @dist = params['dist']
  @hs_type = params['hs_type']
  @flats = settings.flats.group(params['n_rooms'], params['dist'], params['hs_type'])
  erb :matched_flats
end

post '/satisfy_request' do
  flat_index = settings.flats.find(params['flat_address'])
  settings.flats.remove(flat_index)
  settings.requests.remove(params['request_index'])
  redirect('/show_flats')
end

def get_districts
  districts = {}
  # create hash of all districts
  flats = settings.flats
  flats.each do |flat|
    dist = flat.address.district
    districts[dist] = nil unless districts.key?(dist)
  end

  reqs = settings.requests
  reqs.each do |req|
    dist = req.district
    districts[dist] = nil unless districts.key?(dist)
  end
  districts
end

get '/statistics' do
  @districts = get_districts
  # obtain statistics
  flats = settings.flats
  requests = settings.requests
  @districts.each_key do |key|
    # amount of flats, mean square, mean price, amount of requests, coverage
    dist_info = { a_flats: 0, m_sqr: 0, m_prc: 0, a_reqs: 0, cov: 0 }
    flats.each do |flat|
      next unless key == flat.address.district

      dist_info[:a_flats] += 1
      dist_info[:m_sqr] += flat.square.to_i
      dist_info[:m_prc] += flat.price.to_i
    end
    nm_flats = 0
    requests.each do |req|
      next unless key == req.district

      dist_info[:a_reqs] += 1
      m_flats = flats.group(req.n_rooms, req.district, req.hs_type)
      nm_flats += m_flats[0].length
    end
    dist_info[:cov] = (nm_flats.to_f / dist_info[:a_reqs]) unless dist_info[:a_reqs].zero?
    unless dist_info[:a_flats].zero?
      dist_info[:m_sqr] /= dist_info[:a_flats]
      dist_info[:m_prc] /= dist_info[:a_flats]
    end
    @districts[key] = dist_info
  end

  erb :statistics
end
