module Api
  class DaysController < ApplicationController
    before_action :authorized, only: [:today, :update_today]

    def today
      @today = Day.today(@user)
    end

    def update_today
      @today = Day.today(@user)

      unless Day.update_data_types_valid?(day_params)
        return render 'api/shared/errors', locals: { errors: 'Invalid types' }, status: :unprocessable_entity
      end

      if @today.update(day_params)
        render :today
      else
        render 'api/shared/errors', locals: { errors: 'Update failed' }, status: :bad_request
      end
    end

    private

    def day_params
      params.permit(:reviewed, :learned)
    end
  end
end
