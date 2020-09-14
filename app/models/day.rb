class Day < ApplicationRecord
  belongs_to :user

  validates :date, presence: true, uniqueness: { scope: :user }
  validates :reviewed, :learned, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  def self.today(user)
    today = find_by(date: Date.current, user: user)

    today.present? ? today : Day.create(date: Date.current, user: user)
  end
end
