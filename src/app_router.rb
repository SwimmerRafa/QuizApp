require 'sinatra/base'
require './controllers/quiz_app'
require './controllers/manager_app'

#class that models the web server and the routes allowed
class App_Router < Sinatra::Base

  # Quiz routes

  # Route of main page
  get '/' do
    init
  end

  # Route that shows the set up quiz
  get '/start-quiz' do
    start_quiz
  end

  # Route that receives and saves the score of each quiz and render back the top 10 table of scores
  post '/scores' do
    scores
  end

  # Route that receives the set up info and render back the quiz
  post '/quiz' do
    quiz
  end

  # Route that receives the user answers and render back the feedback after submitting a quiz
  post '/get-feedback' do
    get_feedback
  end

  # Manager routes

  # Route that shows the login form
  get '/login' do
    login
  end

  # Route that shows the form to upload the csv file to fill the DB
  get '/upload-csv' do
    view_upload_csv
  end

  # Route that flush the pool of questions in the DB
  get '/delete-questions' do
    delete_questions
  end

  # Route that receives the login info and if it's valid render back the table of questions
  post '/question' do
    question
  end

  # Route that receives the csv file to file to fill the DB
  post '/upload-csv' do
    upload_csv
  end
end

App_Router.run!



