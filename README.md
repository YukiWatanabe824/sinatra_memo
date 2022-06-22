# メモアプリ
## アプリの概要
メモのタイトルとその内容とを保存できるアプリです。
## 使用手順
```
$ git clone https://github.com/YukiWatanabe824/sinatra_memo.git
$ gem install bundler
$ bundle install

# データベースの設定
PostgreSQLをインストールし、任意の名称でDBを作成後、以下の内容でテーブルを作成する。

postgres=# CREATE TABLE memo(id serial not null, title varchar(25) not null, content varchar(100) not null);

# データベースの接続設定
環境変数を設定する

"環境変数名"        |  内容
"FY_MEMO_DATABASE"  |  データベース名
"FY_MEMO_HOST"      |  ローカルホスト
"FY_MEMO_USER"      |  使用するユーザー名
"FY_MEMO_PORT"      |  使用しているポート
"FY_MEMO_PASSWORD"  |  PostgreSQLへの接続パスワード

# プログラムの実行
$ budnle exec ruby memo.rb
```
その後、ブラウザで "http://localhost:4567/" にアクセス
