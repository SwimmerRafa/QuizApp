require 'json'
require 'aws-sdk-dynamodb'

# DynamoDB constants
DYNAMODB = Aws::DynamoDB::Client.new
TABLE_NAME = 'Users'

# Class that represents the http status
class HttpStatus
  OK = 200
  CREATED = 201
  FORBIDDEN = 403
end

# Function that returns the hash of a given json
def parse_body(body)
  if body
    begin
      data = JSON.parse(body)
      data.key?('user') and data.key?('pass') ? data : nil
    rescue JSON::ParserError
      nil
    end
  else
    nil
  end
end

# Function that returns a hashed list of items
def make_result_list(items)
  items.map do |item|
    {
        'User' => item['User'],
        'Password' => item['Password']
    }
  end
end

# Function that validates a given user
def compare_user(body)
  data = parse_body(body)

  items = DYNAMODB.scan(table_name: TABLE_NAME).items

  if data
    res = make_response('', '')

    items.each { |user|
      if user['User'] == data['user'] and user['Password'] == data['pass']
        res = make_response(HttpStatus::OK, {message: 'allowed'})
      elsif user['User'] != data['user']
        res = make_response(HttpStatus::FORBIDDEN, {message: 'user error'})
      else
        res = make_response(HttpStatus::FORBIDDEN, {message: 'pass error'})
      end
    }

    res
  end

end

# Function that generates a http response with their status and body
def make_response(status, body)
  {
      statusCode: status,
      body: JSON.generate(body)
  }
end

# Fuction that handles the http requests to the lambda
def lambda_handler(event:, context:)
  method = event['httpMethod']

  case method
  when 'POST'
    compare_user(event['body'])

  end

end