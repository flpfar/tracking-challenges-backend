require 'rails_helper'

RSpec.describe Day, type: :model do
  context 'validations' do
    it 'is valid with valid attributes' do
      user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')
      day = Day.new(user: user, date: Date.current)

      expect(day).to be_valid
    end

    it 'is not valid without a date' do
      user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')
      day = Day.new(user: user)

      expect(day).not_to be_valid
      expect(day.errors[:date]).to include("can't be blank")
    end

    it 'must have only one date per user' do
      user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')
      Day.create!(user: user, date: Date.current)
      day = Day.new(user: user, date: Date.current)

      expect(day).not_to be_valid
      expect(day.errors[:date]).to include('has already been taken')
    end

    it 'the same date is valid for different users' do
      user1 = User.create!(name: 'User', email: 'user@mail.com', password: '123123')
      user2 = User.create!(name: 'User2', email: 'user2@mail.com', password: '123123')
      Day.create!(user: user1, date: Date.current)
      day = Day.new(user: user2, date: Date.current)

      expect(day).to be_valid
    end
  end

  it 'has default 0 for reviewed and learned' do
    user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')
    day = Day.create!(user: user, date: Date.current)

    expect(day.reviewed).to eq(0)
    expect(day.learned).to eq(0)
  end

  it 'must be destroyed on user deletion' do
    user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')
    Day.create!(user: user, date: Date.current)

    user.destroy

    expect(Day.all).to be_empty
  end

  it '.today returns the current day ' do
    user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')
    day = Day.create!(user: user, date: Date.current)
    reviewed = Measure.create(name: 'Reviewed')
    learned = Measure.create(name: 'Learned')
    Measurement.create!(day: day, measure: reviewed, amount: 2)
    Measurement.create!(day: day, measure: learned, amount: 3)

    today = Day.today(user)

    expect(today.date).to eq(Date.current)
    expect(today.reviewed).to eq(2)
    expect(today.learned).to eq(3)
  end

  it '.today creates and returns a new day if it doesnt exist' do
    user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')

    today = Day.today(user)

    expect(today.date).to eq(Date.current)
    expect(today.reviewed).to eq(0)
    expect(today.learned).to eq(0)
    expect(today.user).to eq(user)
  end
end
