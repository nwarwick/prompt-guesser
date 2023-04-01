class ImagesController < ApplicationController
  prepend_before_action :set_open_ai_client, only: [:new]
  before_action :set_prompt, only: [:new]
  before_action :set_image_url, only: [:new]

  def new
  end

  def create
  end

  def set_open_ai_client
    @client ||= OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"))
  end

  def set_prompt
    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo", # Required.
        messages: [{role: "user", content: "Please create a simple prompt for dall-e."}], # Required.
        temperature: 0.7
      }
    )
    @prompt = response.dig("choices", 0, "message", "content")
    $prompt = @prompt
    puts @prompt
  end

  def set_image_url
    response = @client.images.generate(parameters: {prompt: @prompt, size: "256x256"})
    @image_url = response.dig("data", 0, "url")
  end
end
