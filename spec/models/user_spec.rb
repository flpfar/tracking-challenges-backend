require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(name: 'User', email: 'user@mail.com', password: '123123')

      expect(user).to be_valid
    end

    it 'without a name' do
      user = User.new(email: 'user@mail.com', password: '123123')

      user.valid?

      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'without an email' do
      user = User.new(name: 'User', password: '123123')

      user.valid?

      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'without an unique email' do
      User.create!(name: 'User', email: 'user@mail.com', password: '123123')
      new_user = User.new(name: 'New User', email: 'user@mail.com', password: '123123')

      new_user.valid?

      expect(new_user.errors[:email]).to include('has already been taken')
    end

    it 'with an invalid email' do
      user1 = User.new(name: 'User', email: 'user.com', password: '123123')
      user2 = User.new(name: 'User', email: 'user', password: '123123')
      user3 = User.new(name: 'User', email: 'user@.', password: '123123')
      user4 = User.new(name: 'User', email: '@.com', password: '123123')
      user5 = User.new(name: 'User', email: 'a@com', password: '123123')

      expect(user1).not_to be_valid
      expect(user2).not_to be_valid
      expect(user3).not_to be_valid
      expect(user4).not_to be_valid
      expect(user5).not_to be_valid
    end

    it 'without a password' do
      user = User.new(name: 'User', email: 'user@mail.com')

      user.valid?

      expect(user.errors[:password]).to include("can't be blank")
    end
  end

  context 'daily_goal validations' do
    it 'must be greater than 0' do
      user = User.new(name: 'User', email: 'user@mail.com', password: '123123', daily_goal: 0)

      user.valid?

      expect(user.errors[:daily_goal]).to include('must be greater than 0')
    end

    it 'must be an integer' do
      user = User.new(name: 'User', email: 'user@mail.com', password: '123123', daily_goal: 'oi')

      user.valid?

      expect(user.errors[:daily_goal]).to include('is not a number')
    end
  end

  it 'woking days returns the days with reviews and learned != 0' do
    user = User.create!(name: 'User', email: 'user@mail.com', password: '123123', daily_goal: 1)
    day1 = Day.create!(date: Date.current, user: user)
    day2 = Day.create!(date: Date.current - 1, user: user)
    day3 = Day.create!(date: Date.current - 2, user: user)
    day4 = Day.create!(date: Date.current - 3, user: user)
    Day.create!(date: Date.current - 4, user: user)
    Day.create!(date: Date.current - 5, user: user)
    reviewed = Measure.create(name: 'Reviewed')
    learned = Measure.create(name: 'Learned')
    Measurement.create!(day: day1, measure: reviewed, amount: 6)
    Measurement.create!(day: day1, measure: learned, amount: 1)
    Measurement.create!(day: day2, measure: reviewed, amount: 4)
    Measurement.create!(day: day2, measure: learned, amount: 2)
    Measurement.create!(day: day3, measure: learned, amount: 1)
    Measurement.create!(day: day4, measure: reviewed, amount: 1)

    expect(user.working_days_count).to eq(4)
  end

  it 'total challenges returns the number of challenges solved so far' do
    user = User.create!(name: 'User', email: 'user@mail.com', password: '123123', daily_goal: 1)
    day1 = Day.create!(date: Date.current, user: user)
    day2 = Day.create!(date: Date.current - 1, user: user)
    day3 = Day.create!(date: Date.current - 2, user: user)
    day4 = Day.create!(date: Date.current - 3, user: user)
    Day.create!(date: Date.current - 4, user: user)
    Day.create!(date: Date.current - 5, user: user)
    reviewed = Measure.create(name: 'Reviewed')
    learned = Measure.create(name: 'Learned')
    Measurement.create!(day: day1, measure: reviewed, amount: 6)
    Measurement.create!(day: day1, measure: learned, amount: 1)
    Measurement.create!(day: day2, measure: reviewed, amount: 4)
    Measurement.create!(day: day2, measure: learned, amount: 2)
    Measurement.create!(day: day3, measure: reviewed, amount: 6)
    Measurement.create!(day: day3, measure: learned, amount: 1)
    Measurement.create!(day: day4, measure: reviewed, amount: 1)

    expect(user.total_challenges).to eq(21)
  end
end
