require 'rails_helper'

RSpec.describe 'Day' do
  context 'GET /today' do
    it 'user must be authorized' do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = expired_token_generator(user.id)
      Day.create!(date: Date.today, reviewed: 4, learned: 2, user: user)

      get '/api/today', headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['day']).not_to be_present
      expect(JSON.parse(response.body)['errors']).to be_present
      expect(JSON.parse(response.body)['errors']).to include('Please log in')
    end

    it "returns data of user's current day" do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = token_generator(user.id)
      Day.create!(date: Date.today, reviewed: 4, learned: 2, user: user)

      get '/api/today', headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['day']).to be_present
      expect(JSON.parse(response.body)['day']['date']).to eq(Date.today.to_s)
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
      expect(JSON.parse(response.body)['day']['date']).to eq(Date.today.to_s)
      expect(JSON.parse(response.body)['day']['reviewed']).to eq(0)
      expect(JSON.parse(response.body)['day']['learned']).to eq(0)
    end
  end

  context 'PATCH /today' do
    it 'user must be authorized' do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = expired_token_generator(user.id)
      Day.create!(date: Date.today, reviewed: 4, learned: 2, user: user)

      patch '/api/today', params: { reviewed: 5 }, headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['day']).not_to be_present
      expect(JSON.parse(response.body)['errors']).to be_present
      expect(JSON.parse(response.body)['errors']).to include('Please log in')
    end

    it 'updates today data and returns the day object' do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = token_generator(user.id)
      Day.create!(date: Date.today, reviewed: 4, learned: 2, user: user)

      patch '/api/today', params: { reviewed: 5 }, headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['day']).to be_present
      expect(JSON.parse(response.body)['day']['date']).to eq(Date.today.to_s)
      expect(JSON.parse(response.body)['day']['reviewed']).to eq(5)
      expect(JSON.parse(response.body)['day']['learned']).to eq(2)
    end

    it 'returns errors when fails to update' do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = token_generator(user.id)
      Day.create!(date: Date.today, reviewed: 4, learned: 2, user: user)
      my_params = { reviewed: 'String', learned: '[2, 6]' }

      patch '/api/today', params: my_params, headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['day']).not_to be_present
      expect(JSON.parse(response.body)['errors']).to be_present
      expect(JSON.parse(response.body)['errors']).to include('Invalid types')
    end
  end
end
