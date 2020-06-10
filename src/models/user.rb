require 'json'

# Class that models the
class User
  attr_accessor :user, :pass

  # Function that initialize the username and password
  def initialize(user_name, password)
    @user = user_name
    @pass = password
  end

  # Function that returns the password of the user replaced with "*"
  def hide
    encrypted = ""
    @pass.each_char {|i| encrypted += "*"}
    encrypted
  end

end

