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
      render :new, status: :unprocessable_entity, notice: "At least try to guess something"
    end
  end

  def calculate_score(guess_text)
    # TODO:
    @score = guess_text.similar($prompt).round
  end

  private

  def guess_params
    params.require(:guess).permit(:text)
  end
end
