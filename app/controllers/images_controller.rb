class ImagesController < ApplicationController
  prepend_before_action :set_open_ai_client, only: [:new]
  before_action :set_prompt, only: [:new]
  before_action :set_image_url, only: [:new]

  def new
    # render partial: 'image'
  end

  def create
  end

  def set_open_ai_client
    @client = OpenAI::Client.new(access_token: Rails.application.credentials.openai[:access_token], log_errors: true)
  end

  def set_prompt
    puts 'setting prompt'
    begin
      response = @client.chat(
        parameters: {
          model: 'gpt-3.5-turbo', # Fixed model name
          messages: [{ role: 'user', content: 'Please create a simple prompt for dall-e.' }],
          temperature: 0.7
        }
      )
      @prompt = response.dig('choices', 0, 'message', 'content')
      raise 'Failed to generate prompt' if @prompt.nil?

      $prompt = @prompt
      puts @prompt
    rescue Faraday::TooManyRequestsError => e
      flash.now[:error] = 'Rate limit exceeded. Please try again in a few moments.'
      render :new, status: :unprocessable_entity and return
    rescue StandardError => e
      flash.now[:error] = "An error occurred: #{e.message}"
      render :new, status: :unprocessable_entity and return
    end
  end

  def set_image_url
    return unless @prompt.present?

    begin
      response = @client.images.generate(parameters: { prompt: @prompt, size: '256x256' })
      @image_url = response.dig('data', 0, 'url')
      raise 'Failed to generate image URL' if @image_url.nil?
    rescue Faraday::TooManyRequestsError => e
      flash.now[:error] = 'Rate limit exceeded. Please try again in a few moments.'
      render :new, status: :unprocessable_entity and return
    rescue StandardError => e
      flash.now[:error] = "An error occurred: #{e.message}"
      render :new, status: :unprocessable_entity and return
    end
  end
end
