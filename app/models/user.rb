class User < ApplicationRecord
  has_secure_password
  has_many :days, dependent: :destroy

  validates :name, :email, :password_digest, presence: true
  validates :email, uniqueness: true
  validates :daily_goal, numericality: { greater_than: 0, only_integer: true }

  def working_days
    days.where('reviewed > 0 OR learned > 0')
  end

  def total_challenges
    working_days.sum('reviewed + learned')
  end
end
