require 'json'
require 'aws-sdk-dynamodb'

# DynamoDB constants
DYNAMODB = Aws::DynamoDB::Client.new
TABLE_NAME = 'Questions'

# Class that represents the http status
class HttpStatus
  OK = 200
  CREATED = 201
  BAD_REQUEST = 400
end

# Function that returns a hashed list of items
def make_result_list(items)
  items.map do |item|
    {
        'Question' => item['Question'],
        'Options' => item['Options'].split(',').collect(&:strip),
        'Answer' => item['Answer'].to_i,
    }
  end
end

# Function that generates a http response with their status and body
def make_response(status, body)
  {
      statusCode: status,
      body: JSON.generate(body)
  }
end

# Function that returns all the items from DynamoDB table
def get_items
  DYNAMODB.scan(table_name: TABLE_NAME).items
end

# Functio that parse all the DynamoDB items to hash objects
def get_questions
  items = get_items
  make_response(HttpStatus::OK, make_result_list(items))
end

# Function that upload the questions to DynamoDB
def upload_questions(questions)
  questions.each do |question|
    DYNAMODB.put_item({
                          table_name: TABLE_NAME,
                          item: question
                      })
  end
end

# Function that deletes all the pool of data in DynamoDB
def delete_questions
  items = get_items


  keys = []
  items.map do |item|
    keys << {
        'Question' => item['Question'],
        'Answer' => item['Answer'].to_i
    }
  end

  keys.each do |key|
    DYNAMODB.delete_item({
                             table_name: TABLE_NAME,
                             key: key
                         })
  end

  make_response(HttpStatus::OK, {meesage: 'questions deleted'})
end

# Function that uploads a block of questions to DynamoDB and then retrieves it
def manage_question(body)
  upload_questions(JSON.parse(body)['questions'])
  get_questions
end

# Fuction that handles the http requests to the lambda
def lambda_handler(event:, context:)
  method = event['httpMethod']

  case method
  when 'GET'
    get_questions

  when 'POST'
    manage_question(event['body'])

  when 'DELETE'
    delete_questions

  end

end