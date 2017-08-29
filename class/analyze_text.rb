# name: analyze_text.rb
# note: テキスト解析用
# written by ikeay
require 'nkf'
require './class/pattern.rb'

class AnalyzeText
  # 会話パターン一覧
  Patterns = [
    ExplainPattern.new(
      /お互い大人なんだし/, "お前冷静にな"
    ),
    ExplainPattern.new(
      /どこでもいい|どっちでもいい/, "お前が決めろ"
    ),
    ExplainPattern.new(
      /どうしたの\?|大丈夫\?/, "めんどくさいな"
    ),
    ExplainPattern.new(
      /あっそ|やだ|意味分かん|いみわかん|意味分から|いみわから|ふざけ(んな|てるの|ないで)|なんなの|嫌い|きらい/, "怒ってるから機嫌とって"
    ),
    ExplainPattern.new(
      /別れよう/, "引き止めて"
    ),
    ExplainPattern.new(
      /疲れた/, "今日は何もできない"
    ),
    ExplainPattern.new(
      /見て見て|みてみて|褒めて|ほめて/, "可愛いって言って"
    ),
    ExplainPattern.new(
      /ごめん/, "寛大な心で全部受け止めてくれると嬉しいです"
    ),
    ExplainPattern.new(
      /浮気/, "浮気は論外"
    ),
    ExplainPattern.new(
      /^は\?/, "怒ってるから機嫌とって"
    ),
  ]

  def initialize(text)
    @text = normalize(text)
  end

  # テキストに対する返答を返す
  # 返答がなければnilを返す
  def result
    Patterns.each do |pattern|
      if pattern.match?(@text)
        return pattern.response
      end
    end
    nil
  end

  private

  # テキストからゴミなどを取り除き正規化する
  def normalize(text)
    # 記号や英数字は全角を半角に変換する
    text = NKF.nkf('-m0Z1 -W -w', text)

    # 空白は全部消す
    text = text.gsub(/ +/, '')

    text
  end
end