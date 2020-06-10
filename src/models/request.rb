require 'faraday'

# Class that models the requests to a certain url
class Request

  # Function that represents the HTTP GET
  def self.get_request(route)
    Faraday.get(route)
  end

  # Function that represents the HTTP POST
  def self.post_request(route, body)
    response = Faraday.post(route) do |request|
      request.body = body.to_json
    end

    response
  end

  # Function that represents the HTTP DELETE
  def self.delete_request(route)
    Faraday.delete(route)
  end

  # Function that parse the HTTP response into a hash object
  def self.manage_response(response)
    if response.success?
      JSON.parse(response.body)
    else
      {status: response.status, message: 'failed'}
    end
  end
end
