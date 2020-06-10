# Class that models a quiz object
class Quiz
  attr_accessor :questions, :question_answer, :user_answer

  # Function that initialize the quiz object attributes
  def initialize
    @questions = []
    @question_answer = []
    @user_answer = []
  end

  # Function that returns the number of correct answers in the quiz
  def number_corrects
    corrects = 0

    (0..@question_answer.length() - 1).each do |idx|
      corrects += @question_answer[idx] == @user_answer[idx] ? 1 : 0
    end

    corrects
  end

end
