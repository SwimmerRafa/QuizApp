require './models/game'
require './models/request'
require './models/question'

# url of AWS lambdas
URL_GET_QUESTIONS = 'https://zbpbzqjeje.execute-api.us-east-1.amazonaws.com/default/get_questions'
URL_SCORES = 'https://ezq2yyaea4.execute-api.us-east-1.amazonaws.com/default/scores'

# Creation of a new game class instance
$game = Game.new

# Function that render the welcome page
def init
  @title_page = 'Pine app'
  erb :welcome, layout: :template
end

# Function that render the set up quiz page
def start_quiz
  @title_page = 'Quiz'
  erb :start, layout: :template
end

# Function that save the score info after a quiz and render back the top 10 score table
def scores
  @title_page = 'Scores'
  $game.player.score = params['grade'].to_i

  @username = $game.player.username
  @score = $game.player.score

  response = Request.post_request(URL_SCORES, {
      username: $game.player.username,
      score: $game.player.score
  })

  @scores = Request.manage_response(response)

  erb :scores, layout: :template
end

# Function that render the questionnaire after filling the set up quiz page
def quiz
  $game.new_quiz
  @title_page = 'Quiz app'

  number_questions = params['question_number'].to_i
  puts number_questions
  $game.player.username = params['username']

  if number_questions < 1 or number_questions > 10
    redirect '/start-quiz'
  else
    response = Request.post_request(URL_GET_QUESTIONS, {
        number: number_questions
    })

    questions_response = Request.manage_response(response)

    questions_response.each do |question|
      $game.quiz.question_answer << question['Answer']
      $game.quiz.questions << Question.new(question)
    end
    @questions = $game.quiz.questions

    if @questions.empty?
      redirect '/start-quiz'
    else
      erb :quiz, layout: :template
    end
  end
end

# Function that render the feedback, based on the user answers
def get_feedback
  @title_page = 'Feedback'

  params.each { |question, answer| $game.quiz.user_answer << answer.to_i }

  $game.player.score = ($game.quiz.number_corrects * 100) / $game.quiz.question_answer.length
  @feedback = $game.player.score

  @questions = $game.quiz.questions
  @user_answer = $game.quiz.user_answer

  erb :feedback, layout: :template
end
