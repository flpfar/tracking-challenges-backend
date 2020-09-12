require 'rails_helper'

RSpec.describe 'Authentication' do
  context 'POST /signup' do
    it 'returns user and token' do
      user = { name: 'User', email: 'user@user.com', password: '123123' }

      post '/api/signup', params: { user: user }

      expect(JSON.parse(response.body)['user']).to be_present
      expect(JSON.parse(response.body)['user']['name']).to eq('User')
      expect(JSON.parse(response.body)['token']).to be_present
    end
  end
end
