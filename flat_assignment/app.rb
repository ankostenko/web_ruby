require 'sinatra'
require_relative 'lib/flats_holder'
require_relative 'lib/flat'
require_relative 'lib/request'
require_relative 'lib/request_holder'

configure do
  set :flats, FlatHolder.new([
    # square, numbder of rooms, address, floor, house type, number of floors, price 
    Flat.new(123, 2, "Address", 3, "Brick", 5, 12300),
    Flat.new(123, 2, "Addr", 3, "Brick", 10, 12300),
    Flat.new(123, 2, "Addrs", 3, "Panel", 5, 12300),
  ])

  set :requests, RequestHolder.new([
    # number of rooms, district, hs_type
    Request.new(3, "District #1", "Panel"),
    Request.new(4, "District #2", "Brick") 
  ])
end 

get '/' do
  @flats = settings.flats
  @requests = settings.requests
  erb :index 
end

get '/main' do
  @flats = settings.flats
  @requests = settings.requests
  erb :index
end

get '/add_flat' do
  erb :add_flat
end

post '/add_flat' do
  flat = Flat.new(params['square'], params['n_rooms'], params['address'], params['floor'], 
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

get '/delete_request' do
end

post '/delete_request' do
  settings.requests.remove(params['index'])
  redirect('/main')
end

get '/add_request' do
  erb :add_request
end

post '/add_request' do
  request = Request.new(params['n_rooms'], params['district'], params['hs_type'])
  settings.requests.add(request)
  redirect('/main')
end
