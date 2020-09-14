module Api
  class UsersController < ApplicationController
    before_action :authorized, only: [:auto_login, :update_daily_goal]

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

    def update_daily_goal
      if @user.update(daily_goal_params)
        render partial: 'user', locals: { user: @user }
      else
        render 'api/shared/errors', locals: { errors: @user.errors.full_messages }, status: :unauthorized
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    def daily_goal_params
      params.permit(:daily_goal)
    end
  end
end
