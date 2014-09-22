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

  describe 'PUT /users/:user_id' do
    let(:params) { {user: {name: 'Lala'}} }

    context 'with other user' do
      let!(:other) { FactoryGirl.create(:user, name: 'Bob') }

      it 'returns bad request' do
        put "/users/#{other.id}", params, env
        expect(response).to have_http_status(403)
      end
    end

    context 'by admin user' do
      let(:resource_owner) { FactoryGirl.create(:user, name: 'admin') }
      let!(:other) { FactoryGirl.create(:user, name: 'Bob') }

      it 'updates resource' do
        put "/users/#{other.id}", params, env
        expect(response).to have_http_status(200)

        user = JSON.parse(response.body)
        expect(user).to match(
          'id' => other.id,
          'name' => 'Lala'
        )
      end
    end

    context 'with self' do
      it 'updates resource' do
        put "/users/#{resource_owner.id}", params, env
        expect(response).to have_http_status(200)

        user = JSON.parse(response.body)
        expect(user).to match(
          'id' => resource_owner.id,
          'name' => 'Lala'
        )
      end
    end
  end
end
