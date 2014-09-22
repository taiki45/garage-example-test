class User < ActiveRecord::Base
  include Garage::Representer
  include Garage::Authorizable

  class << self
    # Any user resources are public
    def build_permissions(perms, other, target)
      perms.permits! :read, :write
    end
  end

  property :id
  property :name
end
