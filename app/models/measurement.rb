class Measurement < ApplicationRecord
  belongs_to :measure
  belongs_to :day

  validates :day, presence: true, uniqueness: { scope: :measure }
  validates :amount, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  scope :reviewed, -> { joins(:measure).merge(Measure.reviewed) }
  scope :learned, -> { joins(:measure).merge(Measure.learned) }
end
