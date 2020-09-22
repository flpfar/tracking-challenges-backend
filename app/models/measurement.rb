class Measurement < ApplicationRecord
  belongs_to :measure
  belongs_to :day

  scope :reviewed, -> { joins(:measure).merge(Measure.reviewed) }
  scope :learned, -> { joins(:measure).merge(Measure.learned) }
end
