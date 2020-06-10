require 'json'
require 'aws-sdk-dynamodb'

# DynamoDB constants
DYNAMODB = Aws::DynamoDB::Client.new
TABLE_NAME = 'Scores'

# Class that represents the http status
class HttpStatus
  OK = 200
  CREATED = 201
  FORBIDDEN = 403
end

# Function that generates a http response with their status and body
def make_response(status, body)
  {
      statusCode: status,
      body: JSON.generate(body)
  }
end

# Function that returns a hashed list of items
def make_result_list(items)
  items.map do |item|
    {
        'username' => item['username'],
        'score' => item['score'].to_i
    }
  end
end

# Function that returns the Top 10 scores in DB
def get_scores
  items_db = DYNAMODB.scan(table_name: TABLE_NAME).items
  items_hash = make_result_list(items_db)
  items = items_hash.sort_by { |hash| hash['score'] }
  make_response(HttpStatus::OK, items.reverse().first(10))
end

def upload_score(score)
  DYNAMODB.put_item({table_name: TABLE_NAME, item: score})
end

# Function that parse to hash a given score and then retrives the top 10 scores
def manage_score(body)
  begin
    data = JSON.parse(body)
    upload_score(data)
  rescue JSON::ParserError
    nil
  end
  get_scores
end

# Fuction that handles the http requests to the lambda
def lambda_handler(event:, context:)
  method = event['httpMethod']

  case method
  when 'GET'
    get_scores
  when 'POST'
    manage_score(event['body'])
  end
end
