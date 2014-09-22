class User < ActiveRecord::Base
  include Garage::Representer
  include Garage::Authorizable

  class << self
    # This is for collection of resource.
    # Any user resources are public.
    def build_permissions(perms, other, target)
      perms.permits! :read
    end
  end

  # This is for a member of resources.
  #
  # Anyone can read every user.
  # But other can write user only if owned or is admin.
  def build_permissions(perms, other)
    perms.permits! :read

    if self == other
      perms.permits! :write
    elsif other.admin?
      perms.permits! :write
    end
  end

  property :id
  property :name

  def admin?
    email == 'admin@example.com'
  end
end
