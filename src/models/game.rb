require_relative './quiz'
require_relative './player'

#class that models a game object
class Game
  attr_accessor :quiz, :player

  # Function that initialize a new quiz and new player
  def initialize
    @quiz = Quiz.new
    @player = Player.new
  end

  # Function that refresh the instance of the previous quiz
  def new_quiz
    @quiz = Quiz.new
  end
end
