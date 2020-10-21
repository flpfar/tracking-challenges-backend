class User < ApplicationRecord
  has_secure_password
  has_many :days, dependent: :destroy
  has_many :measurements, through: :days

  validates :name, :email, :password_digest, presence: true
  validates :email, uniqueness: true, format: { with: /\A[^\s@]+@[^\s@]+\.[^\s@]+\z/ }
  validates :daily_goal, numericality: { greater_than: 0, only_integer: true }

  def working_days_count
    measurements.where('amount > 0').select(:day_id).distinct.count
  end

  def working_days
    res_hash = {}

    results = measurements.where('amount > 0').includes(:day).includes(:measure).order(date: :desc)
    results.each do |item|
      res_hash[item.day_id] ||= { date: item.day.date.to_s }
      res_hash[item.day_id][item.measure.name.downcase.to_sym] = item.amount
    end
    res_hash.map { |_k, v| v }
  end

  def total_challenges
    measurements.where('amount > 0').sum(:amount)
  end
end
