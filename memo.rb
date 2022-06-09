# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pg'
enable :method_override

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

class Memo
  class << self
    def connect
      @connection = PG.connect()
    end

    def create(title: memo_title, content: memo_content)
      @connection.exec("INSERT INTO memo(title, content) VALUES('#{title}', '#{content}')")
    end

    def select
      @connection.exec('SELECT * FROM memo ORDER BY id')
    end

    def search_select(id: memo_id)
      memo = []
      @connection.exec("SELECT * FROM memo WHERE id = #{id}").each do |result|
        memo = result
      end
      memo
    end

    def update(id: memo_id, title: memo_title, content: memo_content)
      @connection.exec("UPDATE memo SET title = '#{title}', content = '#{content}' WHERE id = #{id}")
    end

    def delete(id: memo_id)
      @connection.exec("DELETE FROM memo WHERE id = #{id}")
    end
  end
end

Memo.connect

get '/' do
  redirect '/memos/'
end

get '/memos/' do
  @memo_list = Memo.select
  erb :memos
end

get '/memos/new/' do
  erb :new_memo
end

post '/memos/' do
  Memo.create(title: params[:title], content: params[:content])
  redirect '/memos/new/'
end

get '/memos/:memo_id/edit' do |memo_id|
  @memo_id = memo_id.to_i
  @memo = []
  if memo = Memo.search_select(id: @memo_id)
    @memo = memo
  else
    redirect :not_found
  end

  erb :edit_memo
end

patch '/memos/:memo/edit' do
  Memo.update(id: params[:id].to_i, title: params[:title], content: params[:content])
  redirect "/memos/#{params[:id]}/edit"
end

delete '/memos/:memo' do
  Memo.delete(id: params[:id].to_i)
  redirect '/memos/'
end

not_found do
  '404 Not Found'
end
