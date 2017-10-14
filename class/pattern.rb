# 会話パターンを定義するクラス
class Pattern
  attr_reader :matcher, :response, :atmosphere_bad_score

  def initialize(matcher, response, atmosphere_bad_score)
    @matcher = matcher
    @response = [response].flatten
    @atmosphere_bad_score = atmosphere_bad_score
  end

  # パターンにマッチするか？
  def match?(text)
    @matcher.match(text) != nil
  end
end

# 返事に必ず「乙女心解説:」とつけるパターン
class ExplainPattern < Pattern
  def initialize(matcher, response, atmosphere_bad_score)
    super(matcher, ["乙女心解説:", response], atmosphere_bad_score)
  end
end