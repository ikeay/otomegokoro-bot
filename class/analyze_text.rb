# name: analyze_text.rb
# note: テキスト解析用
# written by ikeay

class AnalyzeText
  def initialize(text)
    @text = text
  end

  def result
    case @text
    when /どうしたの？|大丈夫？/
      return "乙女心解説:\n" +
             "めんどくさいな"
    when /疲れた/
      return "乙女心解説:\n" +
             "今日は何もできない"
    when /別れよう/
      return "乙女心解説:\n" +
             "引き止めて"
    when /^は？/
      return "乙女心解説:\n" +
             "怒ってるから機嫌とって"
    when /あっそ|やだ|意味分かん|いみわかん|意味分から|いみわから|ふざけんな|ふざけてるの|ふざけないで|なんなの|嫌い|きらい/
      return "乙女心解説:\n" +
             "怒ってるから機嫌とって"
    when /見て見て|みてみて|褒めて|ほめて/
      return "乙女心解説:\n" +
             "可愛いって言って"
    when /浮気/
      return "乙女心解説:\n" +
             "浮気は論外"
    when /どこでもいい|どっちでもいい/
      return "乙女心解説:\n" +
             "お前が決めろ"         
    when /ごめん/
      return "乙女心解説:\n" +
             "寛大な心で全部受け止めてくれると嬉しいです"
    when /お互い大人なんだし/
      return "乙女心解説:\n" +
             "お前冷静にな"
    else
      return nil
    end
  end
end