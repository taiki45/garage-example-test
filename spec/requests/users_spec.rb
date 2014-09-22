require 'rails_helper'

RSpec.describe 'users', type: :request do
  include AuthHelper

  let(:env) do
    {
      accept: 'application/json',
      authorization: authorization_header_value
    }
  end
  let(:params) { {} }

  describe 'GET /users' do
    before do
      %w(Bob Raymonde Golda Lala).each do |name|
        FactoryGirl.create(:user, name: name)
      end
    end

    it 'returns user resources' do
      get '/users', params, env
      expect(response).to have_http_status(200)

      users = JSON.parse(response.body)
      expect(users.size).to eq(5)
      expect(users).to all(
        match(
          'id' => an_instance_of(Fixnum),
          'name' => an_instance_of(String)
        )
      )
    end
  end

  describe 'GET /users/:user_id' do
    let!(:other) { FactoryGirl.create(:user, name: 'Bob') }

    it 'returns other user resource' do
      get "/users/#{other.id}", params, env
      expect(response).to have_http_status(200)

      user = JSON.parse(response.body)
      expect(user).to match(
        'id' => other.id,
        'name' => other.name
      )
    end
  end
end
