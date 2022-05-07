# メモアプリ
## アプリの概要
メモのタイトルとその内容とを保存できるアプリです。
## 使用手順
```
$ git clone https://github.com/YukiWatanabe824/sinatra_memo.git
$ gem install bundler
$ vi Gemfile
  #以下をGemfileに記入
  gem 'pg'
  gem 'sinatra'
  gem 'sinatra-contrib'
  gem 'webrick'

$ bundle install --path vendor/bundle
$ budnle exec ruby memo.rb
```
その後、ブラウザで "http://localhost:4567/" にアクセス
