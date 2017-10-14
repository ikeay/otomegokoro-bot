require 'sinatra'
require 'json'
require 'line/bot'
require './setting'
require './class/analyze_text'

configure do
  uri = URI.parse(REDIS_URL)
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = LINE_CHANNEL_SECRET
    config.channel_token  = LINE_CHANNEL_TOKEN
  }
end

post '/line/callback' do
  body      = request.body.read
  signature = request.env['HTTP_X_LINE_SIGNATURE']

  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each do |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        userId =  event.source['roomId'] || event.source['groupId'] || event.source['userId']
        analyzed_text = AnalyzeText.new(event.message['text'], userId).result
        result = ""
        analyzed_text.each do |r|
          result += r + "\n"
        end
        message = {
          type: 'text',
          text: result.chomp!
        }
        client.reply_message(event['replyToken'], message)
      end
    end
  end
  'OK'
end

