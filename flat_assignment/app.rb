# frozen_string_literal: true

require 'pstore'
require_relative 'lib/flats_holder'
require_relative 'lib/flat'
require_relative 'lib/request'
require_relative 'lib/request_holder'
require_relative 'lib/address'
require_relative 'lib/statistics'

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

configure :test do
  set :flats, FlatHolder.new([
                               # square, number of rooms, address, floor, house type, nubmer of floors, price
                               Flat.new(80, 3, Address.new('Dist #1', 'Str #1', 1), 8, 'Brick', 10, 1_400_000),
                               Flat.new(50, 4, Address.new('Dist #1', 'Str #3', 12), 3, 'Brick', 5, 1_400_000),
                               Flat.new(50, 3, Address.new('Dist #1', 'Str #4', 2), 3, 'Brick', 5, 1_400_000),
                               Flat.new(50, 4, Address.new('Dist #1', 'Str #5', 12), 3, 'Brick', 5, 1_400_000)
                             ])

  set :requests, RequestHolder.new([
                                     # nubmer of rooms, district, type of a house
                                     Request.new(3, 'Dist #1', 'Brick'),
                                     Request.new(4, 'Dist #1', 'Brick'),
                                     Request.new(5, 'Dist #1', 'Brick')
                                   ])
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

get '/statistics' do
  @districts = Statistics.extr_dist(settings.flats, settings.requests)
  @districts.each_key do |dist|
    @districts[dist] = Statistics.district_info(dist, settings.flats, settings.requests)
  end

  erb :statistics
end
