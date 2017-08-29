# 会話パターンを定義するクラス
class Pattern
  attr_reader :matcher, :response

  def initialize(matcher, response)
    @matcher, @response = matcher, [response].flatten
  end

  # パターンにマッチするか？
  def match?(text)
    @matcher.match(text) != nil
  end
end

# 返事に必ず「乙女心解説:」とつけるパターン
class ExplainPattern < Pattern
  def initialize(matcher, response)
    super(matcher, ["乙女心解説:", response])
  end
end