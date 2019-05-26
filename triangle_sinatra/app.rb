require 'sinatra'
require_relative 'lib/triangle_list'

configure do
  set :triangle_list, [TriangleList.new]
end

get '/' do
  erb :index
end

get '/index' do
  erb :index
end

get '/triangles/new' do
  erb :triangle_new
end

get '/triangles' do 
  erb :triangles
end

post '/triangles/new' do
  side_a = params['side_a_form']
  side_b = params['side_b_form']
  side_c = params['side_c_form']
  @triangle_list.push(Triangle.new(a, b, c))
  
  redirect to('/triangles')
end