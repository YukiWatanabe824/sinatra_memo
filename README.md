# メモアプリ
## アプリの概要
メモのタイトルとその内容とを保存できるアプリです。
## 使用手順
```
$ git clone #gitのURL
$ cd メモアプリのディレクトリ
$ gem install bundler
$ vi Gemfile
  #以下をGemfileに記入
  gem 'sinatra'
  gem 'webrick'
  gem 'sinatra-contrib'
$ bundle install --path vendor/bundle
$ budnle exec ruby memo.rb
```
その後、ブラウザで "http://localhost:4567/" にアクセス
