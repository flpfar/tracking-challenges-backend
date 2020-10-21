class Measure < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :reviewed, -> { where(name: 'Reviewed') }
  scope :learned, -> { where(name: 'Learned') }
end
