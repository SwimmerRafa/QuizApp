require 'csv'
require 'daru'
require './models/request'
require './models/user'
require './models/question'

# url of AWS lambdas
URL_USERS = 'https://e8wlv8kik5.execute-api.us-east-1.amazonaws.com/default/users'
URL_QUESTION = 'https://kdlcriiqz6.execute-api.us-east-1.amazonaws.com/default/questions'

# Function that render the log in form
def login
  @title_page = 'Log in'
  erb :login, layout: :session
end

# Function that returns an array of question objects
def check_questions
  response = Request.get_request(URL_QUESTION)
  questions = []
  if response.success?
    data = Request.manage_response(response)
  end
  data.each do |question|
    questions << Question.new(question)
  end
  questions
end

# Function that validates one user object and the render back the table of questions
def question
  @title_page = 'Question'
  user_obj = User.new(params['user'],params['pass'])

  response = Request.post_request(URL_USERS, {
      user: user_obj.user,
      pass: user_obj.pass
  })

  if response.success?
    @questions = check_questions

    if @questions.empty?
      erb :upload, layout: :session
    else
      erb :table, layout: :session
    end
  else
    redirect '/login'
  end
end

# Function that receives a csv file and returns it parsed in json
def parse_json(csv_file)
  data_frame = Daru::DataFrame.from_csv(csv_file)
  data_frame
end

# Function that render the upload csv file form
def view_upload_csv
  @title_page = 'Upload questions'
  erb :upload, layout: :session
end

# Function that saves the questions into the DB and then render the table with questions
def upload_csv
  datafile = params['csv-file']
  begin
    response = Request.post_request(URL_QUESTION, {
        questions: parse_json(datafile['tempfile'])
    })
  rescue
    redirect '/upload-csv'
  end
  @questions = []
  if response.success?
    data = Request.manage_response(response)
    data.each do |question|
      @questions << Question.new(question)
    end
    erb :table, layout: :session
  end
end

# Function that flush the question pool in the DB
def delete_questions
  response = Request.delete_request(URL_QUESTION)
  if response.success?
    redirect '/upload-csv'
  end
end
