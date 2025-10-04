require 'openai'

class NewsFetcher
  def initialize
    @client = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY'])
  end

  def fetch_daily_news
    prompt = <<~PROMPT
      今日の政治ニュースを初心者向けに簡潔にまとめて、JSON形式で返してください。
      JSON形式のキーは "title" と "summary" としてください。
      - title: 50文字程度
      - summary: 200〜300文字
    PROMPT


    response = @client.chat.completions.create(
      model: :"gpt-4o-mini",                 # 例：現行の軽量モデル名
      messages: [{ role: "user", content: prompt }]
    )

    content = response.choices[0].message.content
        # 不要なバッククォートやコードブロックマーカーを除去
    cleaned = content.gsub(/```json|```/, "").strip
    JSON.parse(cleaned)
  rescue JSON::ParserError => e
    Rails.logger.error("JSON parse error: #{e.message}\nResponse: #{content}")
    nil

  rescue => e
    Rails.logger.error("OpenAI API error: #{e.message}")
    nil
  end
end
