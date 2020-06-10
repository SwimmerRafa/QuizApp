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

# Function that returns the list of questions in DynamoDB
def get_questions(number)
  items = (DYNAMODB.scan(table_name: TABLE_NAME).items).shuffle
  items = items.first(number)
  make_response(HttpStatus::OK, make_result_list(items))
end

# Fuction that handles the http requests to the lambda
def lambda_handler(event:, context:)
  method = event['httpMethod']

  case method
  when 'POST'
    get_questions(JSON.parse(event['body'])['number'].to_i)
  end

end
