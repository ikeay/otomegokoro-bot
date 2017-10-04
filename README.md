乙女心解説BOT
====

次の連載に向けて改良中です。  
女の子の気持ちをド直球に代弁してくれるBot。  
[CodeIQ MAGAZINE](https://codeiq.jp/magazine/2017/07/52989/)の連載のために制作しました。

## 連載
- #1 [Bot開発のエキスパートに聞いた！プログラミング初心者こそChatbotを開発すべき理由とは？_[PR]](https://codeiq.jp/magazine/2017/07/52989/)
- #2 [脱シンプルBot！Chatbotプログラムを最大限活用するためには？_[PR]](https://codeiq.jp/magazine/2017/09/53494/)

## 環境
- Ruby 2.3.0, Sinatra
- LINE Messaging API

## Herokuへデプロイ
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)
- デプロイ後、Webhook URLにHerokuのURL`https://xxxx.herokuapp.com/line/callback
`を登録する。`xxxx`はHerokuから発行されたアプリケーションURLに変更。
- その他設定に関するドキュメントは[LINE Messaging APIの公式ドキュメント](https://developers.line.me/ja/docs/messaging-api/getting-started/)

## ローカル実行方法
下記の方法でLINEに接続せず、コンソールで実行できます。

```
bundle install
ruby ./console.rb
```