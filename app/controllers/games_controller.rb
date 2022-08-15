require 'rest-client'

class GamesController < ApplicationController
  attr_accessor :letters

  def new
    @letters = [*'A'..'Z'].sample(10)
  end

  def score
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    response = RestClient.get(url)
    result = JSON.parse(response)
    guess = @word.upcase.split('')
    @letters = params[:@letters].split(' ')
    if (guess - @letters).empty? && result['found']
      @score = "Congratulations! #{@word} is a valid word"
    else
      @score = "Sorry, try again"
    end
  end

  private

  def validate(attempt, grid)
    try = attempt.upcase.chars
    try.all? do |letter|
      try.count(letter) <= grid.count(letter)
    end
  end
end
