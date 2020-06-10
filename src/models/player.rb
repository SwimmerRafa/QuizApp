require 'json'

#Class that represents a player object
class Player
  attr_accessor :username, :score

  # Function that initialize the username and score of a player
  def initialize
    @username = ''
    @score = -1
  end

end
