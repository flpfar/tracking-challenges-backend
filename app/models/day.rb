class Day < ApplicationRecord
  belongs_to :user

  validates :date, presence: true, uniqueness: { scope: :user }

  def self.today(user)
    today = find_by(date: Date.today, user: user)

    today.present? ? today : Day.create(date: Date.today, user: user)
  end

  def self.update_data_types_valid?(data)
    data.each do |_key, value|
      return false unless Integer(value, exception: false)
    end
    true
  end
end
