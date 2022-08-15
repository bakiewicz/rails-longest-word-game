require 'rest-client'

class GamesController < ApplicationController
  attr_accessor :letters

  def new
    @letters = [*'A'..'Z'].sample(10)
    session[:letters] = @letters
  end

  def score
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    response = RestClient.get(url)
    result = JSON.parse(response)
    if result['found'] && validate(@word, session[:letters])
      @score = "Congratulations! #{@word.capitalize} is a valid word"
      @score_num = @word.size**2
    else
      @score = 'Sorry, try again'
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
