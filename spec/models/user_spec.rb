require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(name: 'User', email: 'user@mail.com', password: '123123')

      expect(user).to be_valid
    end

    context 'is not valid' do
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

      it 'without a password' do
        user = User.new(name: 'User', email: 'user@mail.com')

        user.valid?

        expect(user.errors[:password]).to include("can't be blank")
      end
    end
  end
end
