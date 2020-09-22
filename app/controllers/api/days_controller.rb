module Api
  class DaysController < ApplicationController
    before_action :authorized, only: %i[index today update_today]

    def index
      @days = @user.working_days
      @days.each do |item|
        item[:reviewed] ||= 0
        item[:learned] ||= 0
      end
    end

    def today
      @today = Day.today(@user)
    end

    def update_today
      @today = Day.today(@user)

      @today.reviewed.update(amount: params[:reviewed]) if params[:reviewed]
      @today.learned.update(amount: params[:learned]) if params[:learned]

      render :today
    end

    private

    def day_params
      params.permit(:reviewed, :learned)
    end
  end
end
