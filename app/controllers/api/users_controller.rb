module Api
  class UsersController < ApplicationController
    # def signup
    #   @user = User.create(user_params)
    #   if @user.valid?
    #     token = JsonWebToken.encode({ user_id: @user.id })
    #     render json: { user: @user, token: token }
    #   else
    #     errors = json.errors @user.errors.full_messages
    #     render json: { errors: errors }, status: :unprocessable_entity
    #   end
    # end
    def signup
      @user = User.create(user_params)
      if @user.valid?
        @token = JsonWebToken.encode({ user_id: @user.id })
      else
        render partial: 'errors', locals: {errors: @user.errors.full_messages}, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
  end
end
