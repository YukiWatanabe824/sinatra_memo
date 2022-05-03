# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
enable :method_override

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect '/memos/'
end

get '/memos/' do
  @memo_list = []
  Dir.glob('memos/*').sort.each do |memofiles|
    File.open(memofiles, 'r') do |memodata|
      @memo_list << JSON.parse(memodata.read)
    end
  end
  erb :memos
end

get '/memos/new/' do
  erb :new_memo
end

post '/memos/' do
  memoid_list = Dir.glob('memos/*').map { |memofile| memofile.gsub('memos/memo', '').to_i }
  maxid = if memoid_list == []
            0
          else
            memoid_list.max
          end

  File.open("memos/memo#{maxid + 1}.json", 'w') do |file|
    file.print({ id: maxid + 1, title: params[:title], content: params[:content] }.to_json)
  end
  redirect '/memos/new/'
end

get '/memos/:memo/edit' do |m|
  @memo = {}
  File.open("memos/#{m}.json", 'r') do |memodata|
    @memo = JSON.parse(memodata.read)
  end
  erb :edit_memo
end

patch '/memos/:memo/edit' do
  File.open("memos/memo#{params[:id]}.json", 'w') do |file|
    file.print({ id: params[:id], title: params[:title], content: params[:content] }.to_json)
  end
  redirect "/memos/memo#{params[:id]}/edit"
end

delete '/memos/:memo' do
  File.delete("memos/memo#{params[:id]}.json")
  redirect '/memos/'
end

not_found do
  '404 Not Found'
end
