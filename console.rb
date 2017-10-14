#!/bin/env ruby
# コンソールからBotとだけ会話するプログラム
# デバッグ用途
require './class/analyze_text'

uri = URI.parse('localhost:4567')
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

while true
  print "> "
  text = STDIN.gets.chomp
  puts AnalyzeText.new(text, 'xxxxx').result
end
