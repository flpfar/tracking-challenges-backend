module Api
  class UsersController < ApplicationController
    before_action :authorized, only: [:auto_login]

    def signup
      @user = User.create(user_params)
      if @user.valid?
        @token = JsonWebToken.encode({ user_id: @user.id })
        render 'session', locals: { user: @user, token: @token }
      else
        render 'api/shared/errors', locals: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def login
      @user = User.find_by(email: params[:user][:email])

      if @user&.authenticate(params[:user][:password])
        @token = JsonWebToken.encode({ user_id: @user.id })
        render 'session', locals: { user: @user, token: @token }
      else
        render 'api/shared/errors', locals: { errors: ['Invalid email or password'] }, status: :unauthorized
      end
    end

    def auto_login
      render partial: 'user', locals: { user: @user }
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
  end
end
