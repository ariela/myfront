# myfront
自分用のフロントエンド開発用ベース

## 必要な物
- nodejs
- npm
- ruby
- sass
- compass
- coffeescript
- bower

## 使い方
```
npm install
bower install
gulp
```

## gulpタスク

### デフォルト
下記2つのタスクを実行する
* server
* watch

### server
ライブリロード対応のローカルサーバを準備するタスク。

### watch
scss/CoffeeScriptの変更を監視し、変更があった場合に各タスクを実行する。

#### scssが変更された場合のタスク
* css

#### CoffeeScriptが変更された場合のタスク
* js

### build
scss/CoffeeScriptのコンパイルを行うタスク。

* css
* js

### clean
コンパイルで作成されるファイルの削除を行うタスク

* css:clean
* js:clean

### css
CSSを作成する各種タスクを実行する

* css:clean
* css:vendor
* css:compass
* css:build
* css:archive

### css:clean
CSSのビルドファイルをクリアする

### css:vendor
ベンダーディレクトリから必要なCSSを収集する

### css:compass
scssをcompassでビルド

### css:build
cssを結合・最小化する

### css:archive
cssを圧縮する

### js
JavaScriptを作成する各種タスクを実行する

* js:clean
* js:vendor
* js:coffee
* js:build
* js:archive

### js:clean
Javascriptのビルドファイルをクリアする

### js:vendor
ベンダーディレクトリから必要なJavaScriptを収集する

### js:coffee
coffeescriptをビルド

### js:build
javascriptを結合・最小化する

### js:archive
javascriptを圧縮する
