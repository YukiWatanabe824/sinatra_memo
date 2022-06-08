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
      PG.connect()
    end

    def create(title: memo_title, content: memo_content)
      conn = Memo.connect
      conn.exec("INSERT INTO memo(title, content) VALUES('#{title}', '#{content}')")
    end

    def select
      conn = Memo.connect
      conn.exec('SELECT * FROM memo ORDER BY id')
    end

    def search_select(id: memo_id)
      conn = Memo.connect
      conn.exec("SELECT * FROM memo WHERE id = #{id}")
    end

    def update(id: memo_id, title: memo_title, content: memo_content)
      conn = Memo.connect
      conn.exec("UPDATE memo SET title = '#{title}', content = '#{content}' WHERE id = #{id}")
    end

    def delete(id: memo_id)
      conn = Memo.connect
      conn.exec("DELETE FROM memo WHERE id = #{id}")
    end
  end
end

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

get '/memos/:memo/edit' do |m|
  memo_id = m.delete('memo').to_i
  @memo = []
  db_memo_id_list = []
  Memo.select.each do |result|
    db_memo_id_list << result['id'].to_i
  end
  if db_memo_id_list.find { |db_memo_id| db_memo_id == memo_id }
    Memo.search_select(id: memo_id).each do |result|
      @memo = result
    end
  else
    redirect :not_found
  end

  erb :edit_memo
end

patch '/memos/:memo/edit' do
  Memo.update(id: params[:id].to_i, title: params[:title], content: params[:content])
  redirect "/memos/memo#{params[:id]}/edit"
end

delete '/memos/:memo' do
  Memo.delete(id: params[:id].to_i)
  redirect '/memos/'
end

not_found do
  '404 Not Found'
end
