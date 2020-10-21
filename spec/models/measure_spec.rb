require 'rails_helper'

RSpec.describe Measure, type: :model do
  it 'must have a name' do
    measure = Measure.new

    measure.valid?

    expect(measure.errors[:name]).to include("can't be blank")
  end

  it 'name must be unique non case-sensitive' do
    Measure.create!(name: 'Name')
    measure = Measure.new(name: 'name')

    measure.valid?

    expect(measure.errors[:name]).to include('has already been taken')
  end
end
