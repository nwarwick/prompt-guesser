class GuessesController < ApplicationController
  def new
    @guess = Guess.new
  end

  def create
    @guess = Guess.new(guess_params)
    if @guess.valid?
      calculate_score(@guess.text)
      render :score
    else
      render :new, status: :unprocessable_entity, notice: 'At least try to guess something'
    end
  end

  def calculate_score(guess_text)
    max_length = [$prompt.length, guess_text.length].max
    distance = DidYouMean::Levenshtein.distance(guess_text.downcase, $prompt.downcase)
    @score = ((max_length - distance.to_f) / max_length * 100).round
  end

  private

  def guess_params
    params.require(:guess).permit(:text)
  end
end
