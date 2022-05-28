# メモアプリ
## アプリの概要
メモのタイトルとその内容とを保存できるアプリです。
## 使用手順
```
$ git clone https://github.com/YukiWatanabe824/sinatra_memo.git
$ gem install bundler
$ bundle install

# データベースのインストールと設定
$ psql -d postgres
postgres=# CREATE DATABASE memo_sinatra;
postgres=# \c memo_sinatra;
postgres=# CREATE TABLE memo(id serial not null, title varchar(25) not null, content varchar(100) not null);
postgres=# \q

# プログラムの実行
$ budnle exec ruby memo.rb
```
その後、ブラウザで "http://localhost:4567/" にアクセス
