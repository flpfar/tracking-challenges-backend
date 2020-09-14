module Api
  class DaysController < ApplicationController
    before_action :authorized, only: %i[index today update_today]

    def index
      @days = @user.days.order(date: :desc)
    end

    def today
      @today = Day.today(@user)
    end

    def update_today
      @today = Day.today(@user)

      if @today.update(day_params)
        render :today
      else
        render 'api/shared/errors', locals: { errors: @today.errors.full_messages }, status: :bad_request
      end
    end

    private

    def day_params
      params.permit(:reviewed, :learned)
    end
  end
end
