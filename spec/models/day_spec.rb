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
end
