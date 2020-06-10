require 'json'

# Class that models a single question object
class Question
  attr_accessor :question, :options, :answer

  # Function that initialize the attributes of a question from a has object
  def initialize(hash)
    @question = hash['Question']

    @options = []
    hash['Options'].each {|option| @options << option}

    @answer = hash['Answer']
  end

end