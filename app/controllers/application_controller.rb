require 'json_web_token'

class ApplicationController < ActionController::API
  private

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    return unless auth_header

    token = auth_header.split(' ')[1]
    JsonWebToken.decode(token)
  end

  def logged_in_user
    return unless decoded_token

    user_id = decoded_token['user_id']
    @user = User.find_by(id: user_id)
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    return if logged_in?

    render 'api/shared/errors', locals: { errors: ['Please log in'] }, status: :unauthorized
  end
end
