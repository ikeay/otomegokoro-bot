#!/bin/env ruby
# コンソールからBotとだけ会話するプログラム
# デバッグ用途
require './class/analyze_text'

while true
  print "> "
  text = STDIN.gets.chomp
  puts AnalyzeText.new(text).result
end
