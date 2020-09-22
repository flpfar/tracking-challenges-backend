class Day < ApplicationRecord
  belongs_to :user
  has_many :measurements

  validates :date, presence: true, uniqueness: { scope: :user }
  # validates :reviewed, :learned, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  # scope :working_days, -> { where('reviewed > 0 OR learned > 0') }

  def reviewed
    revieweds = measurements.includes(:measure).where('measures.name = ?', 'Reviewed').references(:measures)
    revieweds.present? ? revieweds.first.amount : 0
  end

  def learned
    learneds = measurements.includes(:measure).where('measures.name = ?', 'Learned').references(:measures)
    learneds.present? ? learneds.first.amount : 0
  end

  def self.today(user)
    today = find_by(date: Date.current, user: user)

    today.present? ? today : Day.create(date: Date.current, user: user)
  end
end
