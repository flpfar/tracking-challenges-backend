require 'rails_helper'

RSpec.describe 'Day routes' do
  describe 'GET /today' do
    it 'user must be authorized' do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = expired_token_generator(user.id)
      Day.create!(date: Date.current, reviewed: 4, learned: 2, user: user)

      get '/api/today', headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['day']).not_to be_present
      expect(JSON.parse(response.body)['errors']).to be_present
      expect(JSON.parse(response.body)['errors']).to include('Please log in')
    end

    it "returns data of user's current day" do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = token_generator(user.id)
      Day.create!(date: Date.current, reviewed: 4, learned: 2, user: user)

      get '/api/today', headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['day']).to be_present
      expect(JSON.parse(response.body)['day']['date']).to eq(Date.current.to_s)
      expect(JSON.parse(response.body)['day']['reviewed']).to eq(4)
      expect(JSON.parse(response.body)['day']['learned']).to eq(2)
      expect(JSON.parse(response.body)['day']['user']).not_to be_present
      expect(JSON.parse(response.body)['token']).not_to be_present
    end

    it "returns a new data of user's current day if it doesn't exist" do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = token_generator(user.id)

      get '/api/today', headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['day']).to be_present
      expect(JSON.parse(response.body)['day']['date']).to eq(Date.current.to_s)
      expect(JSON.parse(response.body)['day']['reviewed']).to eq(0)
      expect(JSON.parse(response.body)['day']['learned']).to eq(0)
    end
  end

  describe 'PATCH /today' do
    it 'user must be authorized' do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = expired_token_generator(user.id)
      Day.create!(date: Date.current, reviewed: 4, learned: 2, user: user)

      patch '/api/today', params: { reviewed: 5 }, headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['day']).not_to be_present
      expect(JSON.parse(response.body)['errors']).to be_present
      expect(JSON.parse(response.body)['errors']).to include('Please log in')
    end

    it 'updates today data and returns the day and updated user object' do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = token_generator(user.id)
      Day.create!(date: Date.current, reviewed: 4, learned: 2, user: user)

      patch '/api/today', params: { reviewed: 5 }, headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['day']).to be_present
      expect(JSON.parse(response.body)['day']['date']).to eq(Date.current.to_s)
      expect(JSON.parse(response.body)['day']['reviewed']).to eq(5)
      expect(JSON.parse(response.body)['day']['learned']).to eq(2)
      expect(JSON.parse(response.body)['user']).to be_present
      expect(JSON.parse(response.body)['user']['total_challenges']).to eq(7)
      expect(JSON.parse(response.body)['user']['total_working_days']).to eq(1)
    end

    it 'returns errors when fails to update' do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = token_generator(user.id)
      Day.create!(date: Date.current, reviewed: 4, learned: 2, user: user)
      my_params = { reviewed: 'String', learned: '[2, 6]' }

      patch '/api/today', params: my_params, headers: { Authorization: "Bearer #{token}" }

      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)['day']).not_to be_present
      expect(JSON.parse(response.body)['errors']).to be_present
      expect(JSON.parse(response.body)['errors']).to include('Reviewed is not a number')
      expect(JSON.parse(response.body)['errors']).to include('Learned is not a number')
    end
  end

  describe 'GET /days' do
    it 'user must be authorized' do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = expired_token_generator(user.id)
      Day.create!(date: Date.current, reviewed: 4, learned: 2, user: user)
      Day.create!(date: Date.yesterday, reviewed: 6, learned: 1, user: user)

      get '/api/days', headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['day']).not_to be_present
      expect(JSON.parse(response.body)['errors']).to be_present
      expect(JSON.parse(response.body)['errors']).to include('Please log in')
    end

    it 'returns a sorted array with all worked days from user' do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = token_generator(user.id)
      Day.create!(date: Date.yesterday, reviewed: 4, learned: 2, user: user)
      Day.create!(date: Date.current, reviewed: 6, learned: 1, user: user)
      Day.create!(date: Date.current - 4, reviewed: 6, learned: 0, user: user)
      Day.create!(date: Date.current - 6, reviewed: 0, learned: 0, user: user)

      get '/api/days', headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['days']).to be_present
      expect(JSON.parse(response.body)['days'].size).to eq(3)
      expect(JSON.parse(response.body)['days'][0]['date']).to eq(Date.current.to_s)
      expect(JSON.parse(response.body)['days'][1]['date']).to eq(Date.yesterday.to_s)
      expect(JSON.parse(response.body)['days'][2]['date']).to eq((Date.current - 4).to_s)
      expect(JSON.parse(response.body)['errors']).not_to be_present
    end

    it 'returns only days from user' do
      user1 = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      user2 = User.create!(name: 'User2', email: 'user2@user.com', password: '123123')
      token = token_generator(user1.id)
      Day.create!(date: Date.current - 2, reviewed: 4, learned: 2, user: user1)
      Day.create!(date: Date.current, reviewed: 6, learned: 1, user: user1)
      Day.create!(date: Date.yesterday, reviewed: 6, learned: 1, user: user2)

      get '/api/days', headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['days']).to be_present
      expect(JSON.parse(response.body)['days'].size).to eq(2)
      expect(response.body).to include(Date.current.to_s)
      expect(response.body).not_to include(Date.yesterday.to_s)
    end
  end
end
