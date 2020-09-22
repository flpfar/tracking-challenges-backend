class User < ApplicationRecord
  has_secure_password
  has_many :days, dependent: :destroy
  has_many :measurements, through: :days

  validates :name, :email, :password_digest, presence: true
  validates :email, uniqueness: true, format: { with: /\A[^\s@]+@[^\s@]+\.[^\s@]+\z/ }
  validates :daily_goal, numericality: { greater_than: 0, only_integer: true }

  def working_days_count
    measurements.where('amount > 0').select(:days).distinct.count
  end

  def total_challenges
    measurements.where('amount > 0').sum(:amount)
  end
end
