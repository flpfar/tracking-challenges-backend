class Measurement < ApplicationRecord
  belongs_to :measure
  belongs_to :day
end
