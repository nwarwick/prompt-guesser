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
    Rails.logger.info 'Setting up OpenAI client'
    @client = OpenAI::Client.new(access_token: Rails.application.credentials.openai[:access_token], log_errors: true)
    Rails.logger.info 'OpenAI client set up'
  end

  def set_prompt
    Rails.logger.info 'Generating prompt'
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

      $prompt = @prompt # Using global variables is not recommended in web applications
      Rails.logger.info "Generated prompt: #{@prompt}"
    rescue Faraday::TooManyRequestsError => e
      Rails.logger.error "Rate limit exceeded: #{e.message}"
      flash.now[:error] = 'Rate limit exceeded. Please try again in a few moments.'
      render :new, status: :unprocessable_entity and return
    rescue StandardError => e
      Rails.logger.error "An error occurred while generating prompt: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      flash.now[:error] = "An error occurred: #{e.message}"
      render :new, status: :unprocessable_entity and return
    end
  end

  def set_image_url
    return unless @prompt.present?

    Rails.logger.info 'Generating image URL'
    begin
      response = @client.images.generate(parameters: { prompt: @prompt, size: '256x256' })
      @image_url = response.dig('data', 0, 'url')
      raise 'Failed to generate image URL' if @image_url.nil?
      Rails.logger.info "Generated image URL: #{@image_url}"
    rescue Faraday::TooManyRequestsError => e
      Rails.logger.error "Rate limit exceeded while generating image: #{e.message}"
      flash.now[:error] = 'Rate limit exceeded. Please try again in a few moments.'
      render :new, status: :unprocessable_entity and return
    rescue StandardError => e
      Rails.logger.error "An error occurred while generating image: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      flash.now[:error] = "An error occurred: #{e.message}"
      render :new, status: :unprocessable_entity and return
    end
  end
end
