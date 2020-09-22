class User < ApplicationRecord
  has_secure_password
  has_many :days, dependent: :destroy

  validates :name, :email, :password_digest, presence: true
  validates :email, uniqueness: true, format: { with: /\A[^\s@]+@[^\s@]+\.[^\s@]+\z/ }
  validates :daily_goal, numericality: { greater_than: 0, only_integer: true }

  def working_days
    days.working_days
  end

  def total_challenges
    working_days.sum('reviewed + learned')
  end
end
