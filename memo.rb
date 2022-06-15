# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
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
      @connection = PG.connect(
        dbname: ENV["FY_MEMO_DATABASE"],
        host: ENV["FY_MEMO_HOST"],
        user: ENV["FY_MEMO_USER"],
        port: ENV["FY_MEMO_PORT"],
        password: ENV["FY_MEMO_DATABASE"]
      )
    end

    def create(title: memo_title, content: memo_content)
      @connection.exec_params('INSERT INTO memo(title, content) VALUES( $1, $2 )', [title, content])
    end

    def search
      @connection.exec('SELECT * FROM memo ORDER BY id')
    end

    def select(id: memo_id)
      memo = []
      @connection.exec_params('SELECT * FROM memo WHERE id = $1', [id]).each do |result|
        memo = result
      end
      memo
    end

    def update(id: memo_id, title: memo_title, content: memo_content)
      @connection.exec_params('UPDATE memo SET title = $1, content = $2 WHERE id = $3', [title, content, id])
    end

    def delete(id: memo_id)
      @connection.exec_params('DELETE FROM memo WHERE id = $1', [id])
    end
  end
end

Memo.connect

get '/' do
  redirect '/memos/'
end

get '/memos/' do
  @memo_list = Memo.search
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
  @memo = Memo.select(id: @memo_id)
  if @memo == []
    redirect :not_found
  else
    @memo
  end

  erb :edit_memo
end

patch '/memos/:memo/edit' do |memo_id|
  Memo.update(id: memo_id.to_i, title: params[:title], content: params[:content])
  redirect "/memos/#{params[:id]}/edit"
end

delete '/memos/:memo' do |memo_id|
  Memo.delete(id: memo_id.to_i)
  redirect '/memos/'
end

not_found do
  '404 Not Found'
end
