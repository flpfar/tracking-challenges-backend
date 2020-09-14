require 'rails_helper'

RSpec.describe 'User routes' do
  describe 'POST /signup' do
    it 'returns user and token' do
      user = { name: 'User', email: 'user@user.com', password: '123123' }

      post '/api/signup', params: { user: user }

      expect(JSON.parse(response.body)['user']).to be_present
      expect(JSON.parse(response.body)['user']['name']).to eq('User')
      expect(JSON.parse(response.body)['user']['email']).to eq('user@user.com')
      expect(JSON.parse(response.body)['user']['password']).to be_nil
      expect(JSON.parse(response.body)['token']).to be_present
    end

    context 'when request is invalid' do
      it 'returns status code 422' do
        user = { name: 'User', email: '', password: '123123' }

        post '/api/signup', params: { user: user }

        expect(JSON.parse(response.body)['user']).not_to be_present
        expect(JSON.parse(response.body)['token']).not_to be_present
        expect(response.status).to eq(422)
      end

      it 'returns a failure message' do
        user = { name: '', email: '', password: '123123' }

        post '/api/signup', params: { user: user }

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['errors']).to include("Name can't be blank")
        expect(JSON.parse(response.body)['errors']).to include("Email can't be blank")
      end
    end
  end

  describe 'POST /login' do
    it 'returns user and token' do
      User.create!(name: 'User', email: 'user@user.com', password: '123123')
      user = { email: 'user@user.com', password: '123123' }

      post '/api/login', params: { user: user }

      expect(JSON.parse(response.body)['user']).to be_present
      expect(JSON.parse(response.body)['user']['name']).to eq('User')
      expect(JSON.parse(response.body)['user']['email']).to eq('user@user.com')
      expect(JSON.parse(response.body)['user']['password']).to be_nil
      expect(JSON.parse(response.body)['token']).to be_present
    end

    context 'when request is invalid' do
      it 'returns status code 401 if login fail' do
        user = { email: 'user@user.com', password: '123123' }

        post '/api/login', params: { user: user }

        expect(JSON.parse(response.body)['user']).not_to be_present
        expect(JSON.parse(response.body)['token']).not_to be_present
        expect(response.status).to eq(401)
      end

      it 'returns a failure message' do
        user = { email: 'user@user.com', password: '123123' }

        post '/api/login', params: { user: user }

        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)['errors']).to include('Invalid email or password')
      end
    end
  end

  describe 'GET /auto_login' do
    it 'returns user and token' do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = token_generator(user.id)

      get '/api/auto_login', headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['user']).to be_present
      expect(JSON.parse(response.body)['user']['name']).to eq('User')
      expect(JSON.parse(response.body)['user']['email']).to eq('user@user.com')
      expect(JSON.parse(response.body)['user']['password']).to be_nil
      expect(JSON.parse(response.body)['token']).not_to be_present
    end

    it 'returns status code 401 if invalid token' do
      get '/api/auto_login', headers: { Authorization: "Bearer #{random_token}" }

      expect(JSON.parse(response.body)['user']).not_to be_present
      expect(JSON.parse(response.body)['token']).not_to be_present
      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['errors']).to include('Please log in')
    end

    it 'returns status code 401 if expired token' do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = expired_token_generator(user.id)

      get '/api/auto_login', headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['user']).not_to be_present
      expect(JSON.parse(response.body)['token']).not_to be_present
      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['errors']).to include('Please log in')
    end
  end

  describe 'PATCH /daily_goal' do
    it 'user must be authorized' do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = expired_token_generator(user.id)

      patch '/api/daily_goal', params: { daily_goal: 6 }, headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['day']).not_to be_present
      expect(JSON.parse(response.body)['errors']).to be_present
      expect(JSON.parse(response.body)['errors']).to include('Please log in')
    end

    it 'updates the daily_goal and returns the user' do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = token_generator(user.id)

      patch '/api/daily_goal', params: { daily_goal: 6 }, headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['user']).to be_present
      expect(JSON.parse(response.body)['user']['name']).to eq('User')
      expect(JSON.parse(response.body)['user']['email']).to eq('user@user.com')
      expect(JSON.parse(response.body)['user']['daily_goal']).to eq(6)
      expect(JSON.parse(response.body)['user']['password']).to be_nil
      expect(JSON.parse(response.body)['token']).not_to be_present
    end

    it 'returns errors if update fails' do
      user = User.create!(name: 'User', email: 'user@user.com', password: '123123')
      token = token_generator(user.id)

      patch '/api/daily_goal', params: { daily_goal: 'abc' }, headers: { Authorization: "Bearer #{token}" }

      expect(JSON.parse(response.body)['user']).not_to be_present
      expect(JSON.parse(response.body)['errors']).to be_present
      expect(JSON.parse(response.body)['errors']).to include('Daily goal is not a number')
    end
  end
end
