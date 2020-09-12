module Api
  class UsersController < ApplicationController
    def signup
      @user = User.create(user_params)
      if @user.valid?
        token = JsonWebToken.encode({ user_id: @user.id })
        render json: { user: @user, token: token }
      else
        render json: { error: 'Invalid data' }
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
  end
end
