require 'rails_helper'

RSpec.describe Day, type: :model do
  context 'validations' do
    it 'is valid with valid attributes' do
      user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')
      day = Day.new(user: user, date: Date.today)

      expect(day).to be_valid
    end

    it 'is not valid without a date' do
      user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')
      day = Day.new(user: user)

      expect(day).not_to be_valid
      expect(day.errors[:date]).to include("can't be blank")
    end
  end

  it 'has default 0 for reviewed and learned' do
    user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')
    day = Day.create!(user: user, date: Date.today)

    expect(day.reviewed).to eq(0)
    expect(day.learned).to eq(0)
  end

  it 'must be destroyed on user deletion' do
    user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')
    Day.create!(user: user, date: Date.today)

    user.destroy

    expect(Day.all).to be_empty
  end

  it '.today returns the current day ' do
    user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')
    Day.create!(user: user, date: Date.today, reviewed: 2, learned: 3)

    today = Day.today(user)

    expect(today.date).to eq(Date.today)
    expect(today.reviewed).to eq(2)
    expect(today.learned).to eq(3)
  end

  it '.today creates and returns a new day if it doesnt exist' do
    user = User.create!(name: 'User', email: 'user@mail.com', password: '123123')

    today = Day.today(user)

    expect(today.date).to eq(Date.today)
    expect(today.reviewed).to eq(0)
    expect(today.learned).to eq(0)
    expect(today.user).to eq(user)
  end
end
