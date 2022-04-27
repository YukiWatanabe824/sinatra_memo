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
  @hash = ''
  memofiles = Dir.glob('memos/*').sort
  memofiles.each do |memofile|
    File.open(memofile, 'r') do |memodata|
      JSON.parse(memodata.read).each_value do |memojson|
        @hash += "<li>#{h(memojson['title'])} : #{h(memojson['content'])}"
        @hash += " <a href=\"http://localhost:4567/memos/memo#{h(memojson['id'])}/edit\">修正する</a> </li>"
      end
    end
  end
  erb :memos
end

get '/memos/new/' do
  erb :new_memo
end

post '/memos/' do
  maxid = 0
  oldmemos = []
  memofiles = Dir.glob('memos/*')
  oldmemos = memofiles.map{|memofile| memofile.gsub('memos/memo', '').to_i}
 # memofiles.each do |memofile|
 #   oldmemos << memofile.gsub('memos/memo', '').to_i
 # end
  oldmemos.each do |oldmemo|
    maxid = oldmemo if oldmemo > maxid
  end

  File.open("memos/memo#{maxid + 1}.json", 'w') do |file|
    file.print({ "memo#{maxid + 1}" => { 'id' => maxid + 1, 'title' => h(params[:title]), 'content' => h(params[:content]) } }.to_json)
  end
  redirect '/memos/new/'
end

get '/memos/:memo/edit' do |m|
  @title = ''
  @content = ''
  @id = ''
  File.open("memos/#{m}.json", 'r') do |memodata|
    JSON.parse(memodata.read).each_value do |memojson|
      @id = memojson['id']
      @title = memojson['title']
      @content = memojson['content']
    end
  end
  erb :edit_memo
end

patch '/memos/:memo/edit' do
  File.open("memos/memo#{params[:id]}.json", 'w') do |file|
    file.print({ "memo#{params[:id]}" => { 'id' => params[:id], 'title' => h(params[:title]), 'content' => h(params[:content]) } }.to_json)
  end
  redirect "/memos/memo#{params[:id]}/edit"
end

delete '/memos/delete/:memo' do
  File.delete("memos/memo#{params[:id]}.json")
  redirect '/memos/'
end

not_found do
  '404 Not Found'
end
