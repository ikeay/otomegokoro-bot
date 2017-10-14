require 'nkf'
require 'redis'
require 'json'
require './class/pattern.rb'

class AnalyzeText
  # 会話パターン一覧
  Patterns = [
    ExplainPattern.new(
      /お互い大人なんだし/, "お前冷静にな", 0
    ),
    ExplainPattern.new(
      /どこでもいい|どっちでもいい/, "お前が決めろ", 0
    ),
    ExplainPattern.new(
      /どうしたの\?|大丈夫\?/, "めんどくさいな", 0
    ),
    ExplainPattern.new(
      /あっそ|やだ|意味分かん|いみわかん|意味分から|いみわから|ふざけ(んな|てるの|ないで)|なんなの|嫌い|きらい/, "怒ってるから機嫌とって", 1
    ),
    ExplainPattern.new(
      /別れよう/, "引き止めて", 1
    ),
    ExplainPattern.new(
      /疲れた/, "今日は何もできない", 0
    ),
    ExplainPattern.new(
      /見て見て|みてみて|褒めて|ほめて/, "可愛いって言って", 0
    ),
    ExplainPattern.new(
      /ごめん/, "寛大な心で全部受け止めてくれると嬉しいです", -1
    ),
    ExplainPattern.new(
      /浮気/, "浮気は論外", 0
    ),
    ExplainPattern.new(
      /^は\?/, "怒ってるから機嫌とって", 1
    ),
  ]

  def initialize(text, channel_id)
    @text = normalize(text)
    @channel_id = channel_id
  end

  # テキストに対する返答を返す
  # 返答がなければnilを返す
  def result
    Patterns.each do |pattern|
      if pattern.match?(@text)
        atmosphere_bad_score = add_atmosphere_bad_score(pattern.atmosphere_bad_score)
        arbitration_text = arbitration(atmosphere_bad_score)
        if arbitration_text != nil
          return arbitration_text
        end
        return pattern.response
      end
    end
    nil
  end

  # ケンカを仲裁する
  # 仲裁する必要がないときはnilを返す
  def arbitration(score)
    case score
    when 4
      "ケンカはやめて…"
    when 6
      "ケンカはやめて！！"
    when 8
      "ケンカはやめてーーーー！！！"
    when 10
      "ケンカやめよ(´・ω・｀)？"
    else
      return "…(´・ω・｀)" if score >= 10 && score % 10 == 0
      nil
    end
  end

  # ケンカスコアをプラスする
  def add_atmosphere_bad_score(score)
    del_old_atmosphere_bad_score()
    today = Time.now.strftime("%Y%m%d")
    keys = $redis.keys("atmosphere/#{@channel_id}/#{today}*")
    if keys.empty? then
      now = Time.now.strftime("%Y%m%d%H%M%S")
      $redis.zincrby("atmosphere/#{@channel_id}/#{now}", score, 'bad')
      keys = $redis.keys("atmosphere/#{@channel_id}/#{today}*")
      sum_array = $redis.zrevrange(keys[0], 0, -1, :with_scores => true)
      sum = sum_array[0][1]
    else
      $redis.zincrby(keys[0], score, 'bad')
      sum_array = $redis.zrevrange(keys[0], 0, -1, :with_scores => true)
      sum = sum_array[0][1]
    end
    sum
  end

  # 今日以外のケンカスコアをリセットする
  def del_old_atmosphere_bad_score
    today = Time.now.strftime("%Y%m%d")
    today_keys = $redis.keys("atmosphere/#{@channel_id}/#{today}*")
    if !today_keys.empty?
      today_val = $redis.zrevrange(today_keys[0], 0, -1, :with_scores => true)[0][1]
      keys = $redis.keys("atmosphere/#{@channel_id}/*") 
      keys.each do |key|
        $redis.del(key)
      end
      $redis.zincrby(today_keys[0], today_val, 'bad')
    end
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