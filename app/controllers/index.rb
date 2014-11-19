require 'rubygems'
require 'sinatra'
require 'bigdecimal'

get '/' do
  Item.destroy_all
  Total.destroy_all
  if File.exists?("./public/uploaded.txt")
    File.delete("./public/uploaded.txt")
  end
  erb :index
end

get '/sample' do
  erb :sample
end

post '/upload' do
  @file = params[:file][:tempfile]
  File.open("./public/uploaded.txt", 'wb') do |f|
    f.write(@file.read)
  end
  redirect '/upload'
end

get '/upload' do
  @contents = IO.readlines("./public/uploaded.txt")
  @total = Total.create(amount: BigDecimal.new(@contents[0][1..-1]))
  @menu_items = @contents[1..-1]
  @items = []
  @menu_items.each do |item|
    array = item.split(",$")
    @items << Item.create(name: array[0], cost: BigDecimal.new(array[1]))
  end
  erb :upload
end

get '/solution' do
  @items = Item.all
  @total = Total.last
  solve(@items, @total)
  erb :solution
end

def solve(items, total)
  @solution = []
  order_combination(items, total)
  @solution
end

def order_combination(items, total, partial=[])
  t = total.amount
  s = partial.inject(0){|sum,e| sum += e.cost }
  @solution << partial if s == t
  return if s >= t
  (0..(items.length - 1)).each do |i|
    n = items[i]
    remaining_items = items.drop(i)
    order_combination(remaining_items, total, partial + [n])
  end
end