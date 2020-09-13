require 'rails_helper'
require 'support/token_helper'

RSpec.configure do |c|
  c.include TokenHelper
end

RSpec.describe 'User' do
  context 'POST /signup' do
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

  context 'POST /login' do
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

  context 'GET /auto_login' do
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
end
