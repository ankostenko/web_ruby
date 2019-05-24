require 'sinatra'
require_relative 'lib/flats_holder'
require_relative 'lib/flat'

configure do
  set :flats, FlatHolder.new([
    Flat.new(123, 2, "Address", 3, "Brick", 5, 12300),
    Flat.new(123, 2, "Addr", 3, "Brick", 10, 12300),
    Flat.new(123, 2, "Addrs", 3, "Panel", 5, 12300),
  ])
end 

get '/' do
  @flats = settings.flats
  erb :index 
end

get '/main' do
  erb :index
end

get '/add_flat' do
  erb :add_flat
end

