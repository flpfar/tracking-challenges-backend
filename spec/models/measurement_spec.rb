require 'rails_helper'

RSpec.describe Measurement, type: :model do
  it 'must be unique for each day measure' do
    user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')
    day = Day.create!(user: user, date: Date.current)
    reviewed = Measure.create(name: 'Reviewed')
    Measurement.create!(day: day, measure: reviewed, amount: 2)
    measurement = Measurement.new(day: day, measure: reviewed, amount: 4)

    measurement.valid?

    expect(measurement.errors[:day]).to include('has already been taken')
  end

  it 'accepts different measures for the same day' do
    user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')
    day = Day.create!(user: user, date: Date.current)
    reviewed = Measure.create(name: 'Reviewed')
    learned = Measure.create(name: 'Learned')
    Measurement.create!(day: day, measure: reviewed, amount: 2)
    measurement = Measurement.new(day: day, measure: learned, amount: 4)

    expect(measurement).to be_valid
  end

  it 'amount must be an integer greater than 0' do
    user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')
    day = Day.create!(user: user, date: Date.current)
    reviewed = Measure.create(name: 'Reviewed')
    measurement1 = Measurement.new(day: day, measure: reviewed, amount: -1)
    measurement2 = Measurement.new(day: day, measure: reviewed, amount: 1.4)
    measurement3 = Measurement.new(day: day, measure: reviewed, amount: 'test')
    measurement4 = Measurement.new(day: day, measure: reviewed, amount: 2)

    measurement1.valid?
    measurement2.valid?
    measurement3.valid?
    measurement4.valid?

    expect(measurement1.errors[:amount]).to include('must be greater than or equal to 0')
    expect(measurement2.errors[:amount]).to include('must be an integer')
    expect(measurement3.errors[:amount]).to include('is not a number')
    expect(measurement4.errors[:amount]).to be_empty
  end
end
