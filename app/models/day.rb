class Day < ApplicationRecord
  belongs_to :user
  has_many :measurements

  validates :date, presence: true, uniqueness: { scope: :user }
  # validates :reviewed, :learned, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  # scope :working_days, -> { where('reviewed > 0 OR learned > 0') }

  def reviewed
    revieweds = measurements.reviewed
    return revieweds.first if revieweds.present?

    reviewed_measure = Measure.find_by(name: 'Reviewed')
    measurements.create(measure: reviewed_measure)
  end

  def reviewed_count
    revieweds = measurements.reviewed
    revieweds.present? ? revieweds.first.amount : 0
  end

  def learned
    learneds = measurements.learned
    return learneds.first if learneds.present?

    learned_measure = Measure.find_by(name: 'Learned')
    measurements.create(measure: learned_measure)
  end

  def learned_count
    learneds = measurements.learned
    learneds.present? ? learneds.first.amount : 0
  end

  def self.today(user)
    today = find_by(date: Date.current, user: user)

    today.present? ? today : Day.create(date: Date.current, user: user)
  end
end
