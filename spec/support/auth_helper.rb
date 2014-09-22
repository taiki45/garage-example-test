require 'active_support/concern'

module AuthHelper
  extend ActiveSupport::Concern

  included do
    let(:authorization_header_value) { "Bearer #{access_token.token}" }

    let(:access_token) do
      FactoryGirl.create(
        :access_token,
        resource_owner_id: resource_owner.id,
        scopes: scopes,
        application: application
      )
    end

    let(:resource_owner) { FactoryGirl.create(:user) }
    let(:scopes) { 'public' }
    let(:application) { FactoryGirl.create(:application) }
  end
end
