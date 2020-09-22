class Measure < ApplicationRecord
  scope :reviewed, -> { where(name: 'Reviewed') }
  scope :learned, -> { where(name: 'Learned') }
end
